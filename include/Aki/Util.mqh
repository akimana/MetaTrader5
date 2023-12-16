#property copyright   "akitoshi manabe"
#property link        "https://github.com/akimana/MetaTrader5"
#property version     "1.00"
#property strict

#include <ChartObjects/ChartObjectsLines.mqh>
#include <Tools/DateTime.mqh>

namespace Util {

   string getUninitReasonText(int reasonCode)
   {
      string text="";
      switch(reasonCode)
      {
         case REASON_ACCOUNT:
            text="Account was changed";break;
         case REASON_CHARTCHANGE:
            text="Symbol or timeframe was changed";break;
         case REASON_CHARTCLOSE:
            text="Chart was closed";break;
         case REASON_PARAMETERS:
            text="Input-parameter was changed";break;
         case REASON_RECOMPILE:
            text="Program "+__FILE__+" was recompiled";break;
         case REASON_REMOVE:
            text="Program "+__FILE__+" was removed from chart";break;
         case REASON_TEMPLATE:
            text="New template was applied to chart";break;
         default:text="Another reason";
      }
      return text;
   }

   void changeTime(datetime &time, int hour, int min, int sec=0)
   {
      CDateTime DateTime;
      DateTime.Date(time);
      DateTime.Hour(hour);
      DateTime.Min(min);
      DateTime.Sec(sec);
      time = DateTime.DateTime();
   }
    
   void nextDay(datetime &time, int delta=1)
   {
      CDateTime DateTime;
      DateTime.Date(time);
      DateTime.DayInc(delta);
      time = DateTime.DateTime();
   }

   void prevDay(datetime &time, int delta=1)
   {
      CDateTime DateTime;
      DateTime.Date(time);
      DateTime.DayDec(delta);
      time = DateTime.DateTime();
   }

   /*
    * チャート左上の Ticker を非表示にする。
    */
   void HideTicker()
   {
      ChartSetInteger(ChartID(), CHART_SHOW_TICKER, false);
   }

   string GetSymbolText()
   {
      string period = EnumToString(Period());
      period = StringSubstr(period, 7, StringLen(period));

      string out = Symbol();
      if(StringLen(out) == 6) {
         /* FXの通貨ペアを想定した文字列処理
          * TODO:
          * 銘柄関連の情報を用いた厳密な分岐が良さそう
          */
         string tmp = StringSubstr(out, 3, 3);
         StringReplace(out, tmp, "/");
         StringAdd(out, tmp);
         StringAdd(out, " ");
      }
      StringAdd(out, period);
      StringAdd(out, " ");
      return out;
   }

    
    
   /*
    * 2つの価格 a,b から Pips を算出
    * TODO:　ブローカーにより、1Pip が 0.01円のところと 0.001円のところがあるので両対応したい
    */    
   double CalcPips(double a, double b)
   {
      if ( a < b ) {
         return ((b-a)*1000);
      }
      else if ( a > b) {
         return ((a-b)*1000);
      }
      else {
         return(0);
      }
   }

   /*
    * EnumToString() が期待する PEROIOD_* になるよう、デフォルトは現在のピリオドにする。
    */
   void CheckPeriod(ENUM_TIMEFRAMES &period)
   {
      if (period==PERIOD_CURRENT) {
         period=Period();
      }
   }

   int PeriodToObjTimeframe (ENUM_TIMEFRAMES period=PERIOD_CURRENT)
   {
      string p = EnumToString(period);
      if ( p == "PERIOD_M1" )        return OBJ_PERIOD_M1;
      else if ( p == "PERIOD_M2" )   return OBJ_PERIOD_M2;
      else if ( p == "PERIOD_M3" )   return OBJ_PERIOD_M3;
      else if ( p == "PERIOD_M4" )   return OBJ_PERIOD_M4;
      else if ( p == "PERIOD_M5" )   return OBJ_PERIOD_M5;
      else if ( p == "PERIOD_M6" )   return OBJ_PERIOD_M6;
      else if ( p == "PERIOD_M10" )  return OBJ_PERIOD_M10;
      else if ( p == "PERIOD_M12" )  return OBJ_PERIOD_M12;
      else if ( p == "PERIOD_M15" )  return OBJ_PERIOD_M15;
      else if ( p == "PERIOD_M20" )  return OBJ_PERIOD_M20;
      else if ( p == "PERIOD_M30" )  return OBJ_PERIOD_M30;
      else if ( p == "PERIOD_H1" )   return OBJ_PERIOD_H1;
      else if ( p == "PERIOD_H2" )   return OBJ_PERIOD_H2;
      else if ( p == "PERIOD_H3" )   return OBJ_PERIOD_H3;
      else if ( p == "PERIOD_H4" )   return OBJ_PERIOD_H4;
      else if ( p == "PERIOD_H6" )   return OBJ_PERIOD_H6;
      else if ( p == "PERIOD_H8" )   return OBJ_PERIOD_H8;
      else if ( p == "PERIOD_H12" )  return OBJ_PERIOD_H12;
      else if ( p == "PERIOD_D1" )   return OBJ_PERIOD_D1;
      else if ( p == "PERIOD_W1" )   return OBJ_PERIOD_W1;
      else if ( p == "PERIOD_MN1" )  return OBJ_PERIOD_MN1;
      return OBJ_NO_PERIODS; // 0
   }

   bool EnabledTimeframes (ENUM_TIMEFRAMES period, const int timeframes)
   {
      return (PeriodToObjTimeframe(period) & timeframes) > 0;
   }

}
