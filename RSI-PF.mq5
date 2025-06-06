//+------------------------------------------------------------------+
//|                                                       RSI-PF.mq5 |
//|                                            Copyright 2025, JoeyT |
//|RSI Moving Profit EA                                              |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, JoeyT"
#property link      ""
#property version   "1.00"

#include <Trade\Trade.mqh>
CTrade trade;

#include "PF-Gui.mqh" //GUI for buttons and labels

//+------------------------------------------------------------------+
//| Enum/s                                                           |
//+------------------------------------------------------------------+
enum TradeDirection
{
   Long  = 0,   // Long
   Short = 1,   // Short
   Auto  = 2    // Auto
};

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
input string   lab1           = "---Base---";      // Base
input int      Magic          = 1;                 // Magic Number
input string   Desc           = "1: Rsi-Pf";       // Description

input double   Lot            = 1.0;               // Lot Size
input TradeDirection InpDir   = Auto;              // Trend

input ENUM_TIMEFRAMES MTimeF  = PERIOD_M1;         // Timeframe 1
input ENUM_TIMEFRAMES TimeF2  = PERIOD_M1;         // Timeframe 2
input ENUM_TIMEFRAMES TimeF3  = PERIOD_M1;         // Timeframe 3
input ENUM_TIMEFRAMES TimeF4  = PERIOD_M1;         // Timeframe 4
input ENUM_TIMEFRAMES TimeF5  = PERIOD_M1;         // Timeframe 5

input string   lab2           = "---Long---";      // Long Settings
input double   RsiLongIn      = 28.0;              // RSI Entry (Long)
input double   RsiLongOut     = 70.0;              // RSI Exit (Long)

input string   lab3           = "---Short---";     // Short Settings
input double   RsiShortIn     = 72.0;              // RSI Entry (Short)
input double   RsiShortOut    = 30.0;              // RSI Exit (Short)

input string   lab4           = "---Risk---";      // Risk Management
input int      MaxSpread      = 0;                 // Max Spread (0 = ignore)
input int      PosCount       = 99;                // Max open positions
input double   MaxProfit      = 0.0;               // Max profit (account currency)
input double   MaxRisk        = 0.0;               // Max loss (account currency)

input string   lab5           = "---TimeWindow---";// etc.
input bool     TimeWActive    = true;              // write log
input int      StartHour      = 10;                // Start hr (0–23)
input int      StartMinute    = 00;                // Start min (0–59)
input int      EndHour        = 19;                // End hr (0–23)
input int      EndMinute      = 00;                // End min (0–59)

input string   lab6           = "---etc.---";      // etc.
input bool     LogActive      = true;              // write log

//+------------------------------------------------------------------+
//| External variable                                                |
//+------------------------------------------------------------------+
bool     isClose        = false;
datetime lastActionTime = 0;
string   currentTrend   = "";
double   rsis[5];
int      OpenCount;
double   OpenAmount;
double   maxFloat;
string   trendDir;
double   actStopVal;
double   eValueN;
double   eValueP;

//+------------------------------------------------------------------+
//| Handlers                                                         |
//+------------------------------------------------------------------+
int emaHandle;
int rsiHandle[5];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   trade.SetExpertMagicNumber(Magic);
   
   // convert enum value to string
   trendDir = EnumToString(InpDir);
   
   //Rsi Handlers
   ENUM_TIMEFRAMES tfs[5] = { MTimeF, TimeF2, TimeF3, TimeF4, TimeF5 };
   // create all handler
   for(int i = 0; i < 5; i++)
   {
      rsiHandle[i] = iRSI(_Symbol, tfs[i], 14, PRICE_CLOSE);
      if(rsiHandle[i] == INVALID_HANDLE)
      {
         PrintFormat("ERROR: RSI handle[%d] creation failed for TF=%d, Err=%d",
                     i, tfs[i], GetLastError());
         return(INIT_FAILED);
      }
   }
   
   //Ma Handler
   emaHandle  = iMA(NULL, MTimeF, 200, 0, MODE_EMA, PRICE_CLOSE);
   
   maxFloat = 0;
   actStopVal = 0;
   
   CreateGui();
   
   if(trendDir == "Auto")
      {
       currentTrend = DetectTrend();
       SetTrendLab(true, currentTrend);
      }
   if(trendDir == "Long" || trendDir == "Short")
      {
       currentTrend = trendDir;
       SetTrendLab(false, currentTrend);
      }
   SetTime(TimeToString(TimeCurrent(),TIME_SECONDS));
         
   return(INIT_SUCCEEDED);
  }
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   // remove handlers
   for(int i = 0; i < 5; i++)
      if(rsiHandle[i] != INVALID_HANDLE)
         IndicatorRelease(rsiHandle[i]);
  
   if(emaHandle != INVALID_HANDLE)
      IndicatorRelease(emaHandle);
   
   DeleteGui();
   
  }
  
//+------------------------------------------------------------------+
//| Chart event handler                                             |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(sparam != BtnName1 && sparam != BtnName2)
      return;
   if(id != CHARTEVENT_OBJECT_CLICK)
      return;
   //On Btn
   if(sparam == BtnName1)
     {
      SetButtonState(ObjectGetInteger(0,BtnName1,OBJPROP_STATE,true));
     }
   //Close Btn
   if(sparam == BtnName2)
     {
      if(!BtnState)
        {
         CloseAllPositions();
        }
     }
  }
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   //set the current bar time
   datetime currentBarDate = iTime(NULL, MTimeF, 0);
   
   //get the actual rsi data and the open position/pnl of the robot
   UpdateRSIs();
   GetPositionStats(_Symbol, Magic, OpenCount, OpenAmount);
   
   //update extreme values of the session
   if(OpenCount > 0)
     {
      updateEVal();
     }
   
   //close if match all condition
   actStopVal = floatingRisk();
   if(CloseValidate() && OpenCount > 0)
     {
      CloseAllPositions();
     }
   
   //run if new candle appear in the main time frame
   if(currentBarDate != lastActionTime)
     {
      lastActionTime = currentBarDate;
      
      // set trend automatically
      if(trendDir == "Auto")
         {
          currentTrend = DetectTrend();
          SetTrendLab(true, currentTrend);
         }
         
      if(BtnState 
         && OpenCount < PosCount
         && isTradeTime()
         )
         OrderOpener();
     }
   
   //Set robot floating and server time
   SetStopVal(actStopVal);
   SetFloat(OpenAmount);  
   SetMaxPos(eValueP);
   SetMaxMin(eValueN);
   SetTime(TimeToString(TimeCurrent(),TIME_SECONDS));
  }

//+------------------------------------------------------------------+
//| Count the open positions in its own magic number+symbol          |
//+------------------------------------------------------------------+
void GetPositionStats(const string symbol,
                      const ulong  magicNumber,
                      int         &outCount,
                      double      &outFloatingPL)
{
   outCount      = 0;
   outFloatingPL = 0.0;

   int total = PositionsTotal();               // all open position
   for(int i = 0; i < total; i++)
   {
      // 1) find i elements ticket
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) 
         continue;

      // 2) load byticket
      if(!PositionSelectByTicket(ticket))
         continue;

      // 3) filter by symbol+magic
      if(PositionGetString(POSITION_SYMBOL) != symbol ||
         PositionGetInteger(POSITION_MAGIC) != magicNumber)
         continue;

      // 4) count if good
      outCount++;
      outFloatingPL += PositionGetDouble(POSITION_PROFIT);
   }
}
  
//+------------------------------------------------------------------+
//| DetectTrend: Datact the actual direction of the MA               |
//| by EMA direction                                                 |
//+------------------------------------------------------------------+
string DetectTrend()
  {
   // EMA actual and previous value
   double buf[2];
   
   if(CopyBuffer(emaHandle, 0, 0, 2, buf) != 2)
      return("unknown");  // not enough data

   double emaNow  = buf[1];
   double emaPrev = buf[0];
   return (emaNow > emaPrev ? "Long" : "Short");
  }
  
//+------------------------------------------------------------------+
//| Collecting RSI Values                                            |
//+------------------------------------------------------------------+
void UpdateRSIs()
   {
    double temp[1];
    for(int i = 0; i < 5; i++)
      {
       if(CopyBuffer(rsiHandle[i], 0, 1, 1, temp) == 1)
         rsis[i] = temp[0];
       else
         rsis[i] = EMPTY_VALUE;
      }
   }
  
//+------------------------------------------------------------------+
//| Check if all RSI values allow Long                               |
//+------------------------------------------------------------------+
bool CheckLong(const double &a[])
  {
   if(currentTrend != "Long") return(false);
   for(int i = 0; i < ArraySize(a); i++)
      if(a[i] >= RsiLongIn)
         return(false);
   return(true);
  }

//+------------------------------------------------------------------+
//| Check if all RSI values allow Short                              |
//+------------------------------------------------------------------+
bool CheckShort(const double &a[])
  {
   if(currentTrend != "Short") return(false);
   for(int i = 0; i < ArraySize(a); i++)
      if(a[i] <= RsiShortIn)
         return(false);
   return(true);
  }
  
//+------------------------------------------------------------------+
//| Send Buy orders                                                  |
//+------------------------------------------------------------------+
bool OpenBuy(double lots)
{
   double price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   if(!trade.Buy(lots, NULL, price, 0, 0, Desc))
   {
      Print("Buy Error: ", trade.ResultRetcode(), " – ", trade.ResultComment());
      return false;
   }
   return true;
}

//+------------------------------------------------------------------+
//| Send Sell orders                                                 |
//+------------------------------------------------------------------+
bool OpenSell(double lots)
{
   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(!trade.Sell(lots, NULL, price, 0, 0, Desc))
   {
      Print("Sell Error: ", trade.ResultRetcode(), " – ", trade.ResultComment());
      return false;
   }
   return true;
}  

//+------------------------------------------------------------------+
//| Open orders based on RSI conditions                              |
//+------------------------------------------------------------------+
void OrderOpener()
  {
   if(BtnState && (MaxSpread == 0 || SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) <= MaxSpread))
      {
       // Long entry
       if(CheckLong(rsis))
         {
          OpenBuy(Lot);
         }
       // Short entry
       else if(CheckShort(rsis))
         {
          OpenSell(Lot);
         }
      }
  }

//+------------------------------------------------------------------+
//| Close all symbol+magic position                                  |
//+------------------------------------------------------------------+
void CloseAllPositions()
   {
    // scan positions last to first
    for(int i = PositionsTotal() - 1; i >= 0; i--)
      {
       // querry the i element
       ulong ticket = PositionGetTicket(i);
       if(ticket == 0) 
         continue;

       // load by ticket
       if(!PositionSelectByTicket(ticket))
         continue;

       // check if its symbol+magic
       if(PositionGetString(POSITION_SYMBOL) ==_Symbol &&
         PositionGetInteger(POSITION_MAGIC) == Magic)
         {
          // try to close position
          if(!trade.PositionClose(ticket))
            PrintFormat("Close position %d Error: %s", ticket, trade.ResultComment());
          else
            PrintFormat("Position %d closed successfully.", ticket);
         }
      }
    
    // stop the program if it hit stop 
    if(BtnState 
       && (OpenAmount <= actStopVal && MaxRisk !=0)
       )
      {
       SetButtonState(ObjectGetInteger(0,BtnName1,OBJPROP_STATE,true));
      }  
    // write the log
    logger(LogActive);
      
    maxFloat = 0;
    eValueN = 0;
    eValueP = 0;
   }

//+------------------------------------------------------------------+
//| Check if it can close the position or not                        |
//+------------------------------------------------------------------+
bool CloseValidate()
   {
    if(currentTrend == "Long"
      && (rsis[0] >= RsiLongOut 
         || (OpenAmount >= MaxProfit && MaxProfit != 0)
         || (OpenAmount <= actStopVal && MaxRisk !=0)))
      {
       return true;
      }
    else if(currentTrend == "Short"
      && (rsis[0] <= RsiShortOut
         || (OpenAmount >= MaxProfit && MaxProfit != 0)
         || (OpenAmount <= actStopVal && MaxRisk !=0)))
      {
       return true;
      }  
    else
      {
       return false;
      }
   }
   
//+------------------------------------------------------------------+
//| Float the risk by the  max profit of the trader set              |
//+------------------------------------------------------------------+
double floatingRisk()
   {
    if(OpenAmount > maxFloat)
     {
      maxFloat = OpenAmount;
     }
    return maxFloat - MaxRisk;
   }
 
//+------------------------------------------------------------------+
//| Collecting min max val of the floating                           |
//+------------------------------------------------------------------+
void updateEVal()
   {
    if(eValueN > OpenAmount)
      {
       eValueN = OpenAmount;
      }
    if(eValueP < OpenAmount)
      {
       eValueP = OpenAmount;
      }  
   }
      
//+------------------------------------------------------------------+
//| Make log about P/L max min val after a session                   |
//+------------------------------------------------------------------+
void logger(bool active)
   {
    if(active)
      {
       // Fájl megnyitása írásra (append mód, ha többször futtatod)
       int file_handle = FileOpen(
         _Symbol + "_SessionStats.txt",
         FILE_READ|FILE_WRITE|FILE_TXT|FILE_ANSI
         );
       if(file_handle != INVALID_HANDLE)
         {
          FileSeek(file_handle, 0, SEEK_END);
          string line = StringFormat(
            "%s; %s; MaxProfit=%.2f; MaxFloatingLoss=%.2f; Closed=%.2f\n",
            TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS),
            _Symbol,
            eValueP,
            eValueN,
            OpenAmount
            );
          FileWriteString(file_handle, line);
          FileClose(file_handle);
         }
       else
          Print("Open file Error: ", GetLastError());
      }
   }
   
//+------------------------------------------------------------------+
//| Check if its trade time if turned on                             |
//+------------------------------------------------------------------+
bool isTradeTime()
   {
    if(TimeWActive)
      {
       MqlDateTime dt;
       TimeToStruct(TimeCurrent(), dt);
       int now  = dt.hour*60 + dt.min;
       int from = StartHour*60 + StartMinute;
       int to   = EndHour*60   + EndMinute;
       // normal interval
       if(from <= to)
         return (now >= from && now <= to);
       // midnight
       return (now >= from || now <= to);
      }
    else
       return false;
   }
//+------------------------------------------------------------------+
