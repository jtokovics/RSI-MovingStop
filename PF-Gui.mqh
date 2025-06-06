//+------------------------------------------------------------------+
//|                                                       PF-Gui.mqh |
//|                                            Copyright 2025, JoeyT |
//|RSI Moving Profit EA                                              |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, JoeyT"
#property link      ""

input color    ClrFont     = clrDarkOrange;    // Font Color

//Button data
const int      Corner         = CORNER_RIGHT_UPPER;
const string   Font           = "Arial Bold";
const int      FontSize       = 12;
const int      BtnHeight      = 30;
const int      BtnWidth       = 150;

const string   BtnName1       = "BTN1";
const string   BtnName2       = "BTN2";

bool           BtnState      = false;

//Panel data
const string   L00Name        = "LINE00";
const string   L01Name        = "LINE01";
const string   L02Name        = "LINE02";
const string   L03Name        = "LINE03";
const string   L04Name        = "LINE04";
const string   L05Name        = "LINE05";
const string   L06Name        = "LINE06";
const string   L07Name        = "LINE07";

//Position
const int      NulXPos     = 200;              
const int      NulYPos     = 10;               
const int      SpaceXPos   = 200;              
const int      SpaceYPos   = 12;     
const int      BtnSpace    = 30; 
//Colors
const color    ClrA  = clrBlack;
const color    ClrB  = C'0,140,145';
const color    ClrC  = clrMediumVioletRed;
const color    ClrD  = clrYellow;

//On/Off Btn
void CreateRunBtn()
   {
    ObjectDelete(0, BtnName1);
    ObjectCreate(0, BtnName1, OBJ_BUTTON, 0, 0, 0);
    ObjectSetInteger(0, BtnName1, OBJPROP_XDISTANCE, NulXPos);
    ObjectSetInteger(0, BtnName1, OBJPROP_YDISTANCE, NulYPos+ BtnSpace);
    ObjectSetInteger(0, BtnName1, OBJPROP_XSIZE, BtnWidth);
    ObjectSetInteger(0, BtnName1, OBJPROP_YSIZE, BtnHeight);
    ObjectSetInteger(0, BtnName1, OBJPROP_CORNER, Corner);
    ObjectSetString(0, BtnName1, OBJPROP_FONT, Font);
    ObjectSetInteger(0, BtnName1, OBJPROP_FONTSIZE, FontSize);
    ObjectSetInteger(0, BtnName1, OBJPROP_COLOR, ClrA);
   
   SetButtonState(BtnState);
   }

//Set button on button click
void SetButtonState(bool state)
   {
    BtnState = state;
      
    ObjectSetInteger(0, BtnName1, OBJPROP_STATE, BtnState);
    ObjectSetString(0, BtnName1, OBJPROP_TEXT, (BtnState?"ON":"OFF"));
    ObjectSetInteger(0, BtnName1, OBJPROP_BGCOLOR, (BtnState?ClrB:ClrC));
    ChartRedraw(0);
   }

void CreateStartBtn()
   {
    ObjectDelete(0, BtnName2);
    ObjectCreate(0, BtnName2, OBJ_BUTTON, 0, 0, 0);
    ObjectSetInteger(0, BtnName2, OBJPROP_XDISTANCE, NulXPos);
    ObjectSetInteger(0, BtnName2, OBJPROP_YDISTANCE, NulYPos+ BtnSpace + 35);
    ObjectSetInteger(0, BtnName2, OBJPROP_XSIZE, BtnWidth);
    ObjectSetInteger(0, BtnName2, OBJPROP_YSIZE, BtnHeight);
    ObjectSetInteger(0, BtnName2, OBJPROP_CORNER, Corner);
    ObjectSetString(0, BtnName2, OBJPROP_FONT, Font);
    ObjectSetInteger(0, BtnName2, OBJPROP_FONTSIZE, FontSize);
    ObjectSetInteger(0, BtnName2, OBJPROP_COLOR, ClrA);
    ObjectSetString(0, BtnName2, OBJPROP_TEXT, "Close All");
    ObjectSetInteger(0, BtnName2, OBJPROP_BGCOLOR, clrWhite);
   }
   
void CreatePanel()
   {
    //Status
    ObjectDelete(0, L00Name);
    ObjectCreate(0, L00Name, OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0,L00Name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetInteger(0,L00Name,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,L00Name,OBJPROP_YDISTANCE,NulYPos + 9 *SpaceYPos);  
    ObjectSetString(0, L00Name, OBJPROP_FONT, Font);
    ObjectSetInteger(0, L00Name, OBJPROP_FONTSIZE, FontSize);
    ObjectSetInteger(0, L00Name, OBJPROP_COLOR, ClrFont);
    ObjectSetString(0, L00Name, OBJPROP_TEXT, "-");
            
    //Time
    ObjectDelete(0,L01Name);
    ObjectCreate(0,L01Name,OBJ_LABEL,0,0,0);
    ObjectSetInteger(0,L01Name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetInteger(0,L01Name,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,L01Name,OBJPROP_YDISTANCE,NulYPos + 11 *SpaceYPos);
    ObjectSetString(0, L01Name, OBJPROP_FONT, Font);
    ObjectSetInteger(0, L01Name, OBJPROP_FONTSIZE, FontSize);
    ObjectSetInteger(0, L01Name, OBJPROP_COLOR, ClrFont);
    ObjectSetString(0, L01Name, OBJPROP_TEXT, "-");
    
    //Session
    ObjectDelete(0,L02Name);
    ObjectCreate(0,L02Name,OBJ_LABEL,0,0,0);
    ObjectSetInteger(0,L02Name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetInteger(0,L02Name,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,L02Name,OBJPROP_YDISTANCE,NulYPos + 13 *SpaceYPos);
    ObjectSetString(0, L02Name, OBJPROP_FONT, Font);
    ObjectSetInteger(0, L02Name, OBJPROP_FONTSIZE, FontSize);
    ObjectSetInteger(0, L02Name, OBJPROP_COLOR, ClrFont);
    ObjectSetString(0, L02Name, OBJPROP_TEXT, "Session:"); 
    
    //Float
    ObjectDelete(0,L03Name);
    ObjectCreate(0,L03Name,OBJ_LABEL,0,0,0);
    ObjectSetInteger(0,L03Name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetInteger(0,L03Name,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,L03Name,OBJPROP_YDISTANCE,NulYPos + 15 *SpaceYPos);
    ObjectSetString(0, L03Name, OBJPROP_FONT, Font);
    ObjectSetInteger(0, L03Name, OBJPROP_FONTSIZE, FontSize);
    ObjectSetInteger(0, L03Name, OBJPROP_COLOR, ClrFont);
    ObjectSetString(0, L03Name, OBJPROP_TEXT, "-"); 
    
    //Actual stop
    ObjectDelete(0,L04Name);
    ObjectCreate(0,L04Name,OBJ_LABEL,0,0,0);
    ObjectSetInteger(0,L04Name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetInteger(0,L04Name,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,L04Name,OBJPROP_YDISTANCE,NulYPos + 17 *SpaceYPos);
    ObjectSetString(0, L04Name, OBJPROP_FONT, Font);
    ObjectSetInteger(0, L04Name, OBJPROP_FONTSIZE, FontSize);
    ObjectSetInteger(0, L04Name, OBJPROP_COLOR, ClrFont);
    ObjectSetString(0, L04Name, OBJPROP_TEXT, "-"); 
    
    //Extreme value +
    ObjectDelete(0,L05Name);
    ObjectCreate(0,L05Name,OBJ_LABEL,0,0,0);
    ObjectSetInteger(0,L05Name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetInteger(0,L05Name,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,L05Name,OBJPROP_YDISTANCE,NulYPos + 19 *SpaceYPos);
    ObjectSetString(0, L05Name, OBJPROP_FONT, Font);
    ObjectSetInteger(0, L05Name, OBJPROP_FONTSIZE, FontSize);
    ObjectSetInteger(0, L05Name, OBJPROP_COLOR, ClrFont);
    ObjectSetString(0, L05Name, OBJPROP_TEXT, "-"); 
    
    //Extreme value -
    ObjectDelete(0,L06Name);
    ObjectCreate(0,L06Name,OBJ_LABEL,0,0,0);
    ObjectSetInteger(0,L06Name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetInteger(0,L06Name,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,L06Name,OBJPROP_YDISTANCE,NulYPos + 21 *SpaceYPos);
    ObjectSetString(0, L06Name, OBJPROP_FONT, Font);
    ObjectSetInteger(0, L06Name, OBJPROP_FONTSIZE, FontSize);
    ObjectSetInteger(0, L06Name, OBJPROP_COLOR, ClrFont);
    ObjectSetString(0, L06Name, OBJPROP_TEXT, "-"); 
    
    //Symbol
    ObjectDelete(0,L07Name);
    ObjectCreate(0,L07Name,OBJ_LABEL,0,0,0);
    ObjectSetInteger(0,L07Name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetInteger(0,L07Name,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,L07Name,OBJPROP_YDISTANCE,NulYPos);
    ObjectSetString(0, L07Name, OBJPROP_FONT, Font);
    ObjectSetInteger(0, L07Name, OBJPROP_FONTSIZE, FontSize);
    ObjectSetInteger(0, L07Name, OBJPROP_COLOR, ClrFont);
    ObjectSetString(0, L07Name, OBJPROP_TEXT, _Symbol); 
   }
   
void CreateGui()
   {
    CreateRunBtn();
    CreateStartBtn();
    CreatePanel();
   } 
 
void DeleteGui()
   {
    ObjectDelete(0,BtnName1);
    ObjectDelete(0,BtnName2);
    ObjectDelete(0,L00Name);
    ObjectDelete(0,L01Name);
    ObjectDelete(0,L02Name);
    ObjectDelete(0,L03Name);
    ObjectDelete(0,L04Name);
    ObjectDelete(0,L05Name);
    ObjectDelete(0,L06Name);
    ObjectDelete(0,L07Name);
   }
   
void SetTime(string time)
   {
    ObjectSetString(0, L00Name, OBJPROP_TEXT, time);
   }

void SetTrendLab(bool auto, string trend)
   {
    if(auto == true)
      {
       ObjectSetString(0, L01Name, OBJPROP_TEXT, "Auto: " + trend);
      }
    else
      {
       ObjectSetString(0, L01Name, OBJPROP_TEXT, trend);
      }
   }
   
void SetFloat(double floating)
   {
    ObjectSetString(0, L03Name, OBJPROP_TEXT, DoubleToString(floating,2) + " " + AccountInfoString(ACCOUNT_CURRENCY));
   }

void SetStopVal(double stopVal)
   {
    ObjectSetString(0, L04Name, OBJPROP_TEXT, "Stop: $" + DoubleToString(stopVal,2));
   }
   
void SetMaxPos(double posVal)
   {
    ObjectSetString(0, L05Name, OBJPROP_TEXT, "Max+: " + DoubleToString(posVal,2));
   }
   
void SetMaxMin(double minVal)
   {
    ObjectSetString(0, L06Name, OBJPROP_TEXT, "Max-: " + DoubleToString(minVal,2));
   }