//------------------------------------------------------------------
#property copyright   "akitoshi manabe"
#property link        "https://github.com/akimana/MetaTrader5"
#property description "チャート銘柄を大きく表示する"
#property version     "1.00"
//------------------------------------------------------------------
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots 0

#property strict
//--- includes
#include <maku77/ErrorUtil.mqh>
#include <Aki/Util.mqh>
#include <ChartObjects/ChartObjectsTxtControls.mqh>

input ENUM_BASE_CORNER InpCornerPos = CORNER_LEFT_UPPER; // 表示位置
input int InpFontSize = 24; // フォントサイズ
input color InpFGColor = clrGray; // 文字の色

//--- グローバル変数
CChartObjectLabel gLabel;
const string SymbolInfoPfx  = "SymbolInfo";
const string SymbolInfoText = "SymbolInfoText";

bool AddSymbolText()
{

   // 表示位置調整用変数 (CORNER_POINTに合せてANCHOR_POINTを変える)
   int dx = 10, dy = 10;
   ENUM_ANCHOR_POINT ap = ANCHOR_CENTER;
   switch (InpCornerPos) {
      case CORNER_LEFT_UPPER:
         ap = ANCHOR_LEFT_UPPER;
         break;
      case CORNER_LEFT_LOWER:
         ap = ANCHOR_LEFT_LOWER;
         dy = InpFontSize;
         break;
      case CORNER_RIGHT_LOWER:
         ap = ANCHOR_RIGHT_LOWER;
         dx = -1;
         dy = InpFontSize;
         break;
      case CORNER_RIGHT_UPPER:
         ap = ANCHOR_RIGHT_UPPER;
         dx = -1;
         break;
   }

   if (gLabel.Create(0, SymbolInfoText, 0, 0, 0)) {

      // 文字列をオブジェクトに割り当た後で横幅を取得する

      // Text
      gLabel.SetString(OBJPROP_TEXT, Util::GetSymbolText());
      gLabel.Font("Arial");
      gLabel.FontSize(InpFontSize);
      gLabel.Color(InpFGColor);
      gLabel.Background(clrNONE);
      
      // Position
      gLabel.Corner(InpCornerPos);
      gLabel.Anchor(ap);
      if (dx==-1)
         dx = gLabel.Width();
      dx += (InpFontSize / 2);
      gLabel.X_Distance(dx);
      gLabel.Y_Distance(dy);
      
      return true;
   }
   ErrorUtil::AlertLastError();
   return false;
}


//------------------------------------------------------------------
// Custom indicator initialization function
//------------------------------------------------------------------
int OnInit()
{
   if (!AddSymbolText()) return INIT_FAILED;
   Util::HideTicker();
   return(INIT_SUCCEEDED); // 初期化成功を返却しないと無効になる
}

void OnDeinit(const int reason)
{
   //Print("インジケータを修了");
   ObjectsDeleteAll(0,SymbolInfoPfx);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   //return(rates_total);
   return(0);
}

