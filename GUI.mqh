
#property copyright "Copyright 2023, JoeyT"
#property link      ""
#property strict

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

//Position
const int      NulXPos     = 175;              
const int      NulYPos     = 10;               
const int      SpaceXPos   = 200;              
const int      SpaceYPos   = 12;     
const int      BtnSpace    = 30; 
//Colors
const color    ClrA  = clrBlack;
const color    ClrB  = RGB(0,140,145);
const color    ClrC  = clrMediumVioletRed;
const color    ClrD  = clrYellow;

//On/Off Btn
void CreateRunBtn()
   {
    ObjectDelete(0,BtnName1);
    ObjectCreate(0,BtnName1,OBJ_BUTTON,0,0,0);
    ObjectSetInteger(0,BtnName1,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,BtnName1,OBJPROP_YDISTANCE,NulYPos+ BtnSpace);
    ObjectSetInteger(0,BtnName1,OBJPROP_XSIZE,BtnWidth);
    ObjectSetInteger(0,BtnName1,OBJPROP_YSIZE,BtnHeight);
    ObjectSetInteger(0,BtnName1,OBJPROP_CORNER,Corner);
    ObjectSetString(0,BtnName1,OBJPROP_FONT,Font);
    ObjectSetInteger(0,BtnName1,OBJPROP_FONTSIZE,FontSize);
    ObjectSetInteger(0,BtnName1,OBJPROP_COLOR,ClrA);
   
   SetButtonState(BtnState);
   }
   
void CreateStartBtn()
   {
    ObjectDelete(0,BtnName2);
    ObjectCreate(0,BtnName2,OBJ_BUTTON,0,0,0);
    ObjectSetInteger(0,BtnName2,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,BtnName2,OBJPROP_YDISTANCE,NulYPos+ BtnSpace + 35);
    ObjectSetInteger(0,BtnName2,OBJPROP_XSIZE,BtnWidth);
    ObjectSetInteger(0,BtnName2,OBJPROP_YSIZE,BtnHeight);
    ObjectSetInteger(0,BtnName2,OBJPROP_CORNER,Corner);
    ObjectSetString(0,BtnName2,OBJPROP_FONT,Font);
    ObjectSetInteger(0,BtnName2,OBJPROP_FONTSIZE,FontSize);
    ObjectSetInteger(0,BtnName2,OBJPROP_COLOR,ClrA);
    ObjectSetString(0,BtnName2,OBJPROP_TEXT,"Start");
    ObjectSetInteger(0,BtnName2,OBJPROP_BGCOLOR,clrWhite);
   }
      
void CreatePanel()
   {
    //Status
    ObjectDelete(0,L00Name);
    ObjectCreate(0,L00Name,OBJ_LABEL,0,0,0);
    ObjectSetInteger(0,L00Name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetText(L00Name,"",FontSize,Font,ClrA);   
    ObjectSetInteger(0,L00Name,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,L00Name,OBJPROP_YDISTANCE,NulYPos + 15 *SpaceYPos);          
    //Time
    ObjectDelete(0,L01Name);
    ObjectCreate(0,L01Name,OBJ_LABEL,0,0,0);
    ObjectSetInteger(0,L01Name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetText(L01Name,"-",FontSize,Font,ClrFont);   
    ObjectSetInteger(0,L01Name,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,L01Name,OBJPROP_YDISTANCE,NulYPos + 11 *SpaceYPos);
    //Float
    ObjectDelete(0,L02Name);
    ObjectCreate(0,L02Name,OBJ_LABEL,0,0,0);
    ObjectSetInteger(0,L02Name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
    ObjectSetText(L02Name,"",FontSize,Font,ClrA);   
    ObjectSetInteger(0,L02Name,OBJPROP_XDISTANCE,NulXPos);
    ObjectSetInteger(0,L02Name,OBJPROP_YDISTANCE,NulYPos + 13 *SpaceYPos);  
    
    SetTime();
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
   }
     
//Set button on button click
void SetButtonState(bool state)
   {
    BtnState = state;
      
    ObjectSetInteger(0,BtnName1,OBJPROP_STATE,BtnState);
    ObjectSetString(0,BtnName1,OBJPROP_TEXT,(BtnState?"ON":"OFF"));
    ObjectSetInteger(0,BtnName1,OBJPROP_BGCOLOR,(BtnState?ClrB:ClrC));
    ChartRedraw(0);
   }
   
void SetTime()
   {
    ObjectSetText(0, L00Name, OBJPROP_TEXT, TimeToString(TimeCurrent(),TIME_SECONDS));
   }
   
void SetState(string trend)
   {
    if(trend == "long")
      {
       ObjectSetText(0, L01Name, OBJPROP_TEXT, "Long ^");
      }
    else
      {
       ObjectSetText(0, L01Name, OBJPROP_TEXT, "Short ˇ");
      }
   }

void SetFloat(string floatStr)
   {
    ObjectSetText(0, L02Name, OBJPROP_TEXT, floatStr + " " + AccountInfoString(ACCOUNT_CURRENCY));
   }