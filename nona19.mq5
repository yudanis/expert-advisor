input int shift=0; 
//+------------------------------------------------------------------+ 
//| Function-event handler "tick"                                    | 
//+------------------------------------------------------------------+ 
void onInit(){
   
}
double lastopen = 0;
int count = 0;
input long magic_number = 2222;

void OnTick() 
  { 
  
  if(lastopen == 0)
      lastopen = iOpen(Symbol(), Period(), 0);
  else{
      double currentOpen = iOpen(Symbol(), Period(), 0);
      if(currentOpen != lastopen){
         count++;
         Comment("NEW CANDLE" + DoubleToString(count));
         bool isUp = false;
         double lastclose = iClose(Symbol(), Period(),1);
         isUp = lastopen < lastclose;
         
         
         MqlTradeRequest request = {0};         
         MqlTradeResult result = {0};
         
         DeleteLastOrder();
         if(isUp)
            OrderBuy(currentOpen, 100, 100, 0.1);
         else
            OrderSell(currentOpen,100, 100, 0.1);
         
         
      }
      lastopen = currentOpen;
   }
   
    
  /*
   datetime time  = iTime(Symbol(),Period(),shift); 
   double   open  = iOpen(Symbol(),Period(),shift); 
   double   high  = iHigh(Symbol(),Period(),shift); 
   double   low   = iLow(Symbol(),Period(),shift); 
   double   close = iClose(NULL,PERIOD_CURRENT,shift); 
   long     volume= iVolume(Symbol(),0,shift); 
   int      bars  = iBars(NULL,0); 
  
   Comment(Symbol(),",",EnumToString(Period()),"\n", 
           "Time: "  ,TimeToString(time,TIME_DATE|TIME_SECONDS),"\n", 
           "Open: "  ,DoubleToString(open,Digits()),"\n", 
           "High: "  ,DoubleToString(high,Digits()),"\n", 
           "Low: "   ,DoubleToString(low,Digits()),"\n", 
           "Close: " ,DoubleToString(close,Digits()),"\n", 
           "Volume: ",IntegerToString(volume),"\n", 
           "Bars: "  ,IntegerToString(bars),"\n" 
           ); 
           
   double currentOpen =
   */
  }
  void OrderBuy(double price, double tpPip, double slPip, double lot){
   MqlTradeRequest request = {0};
   MqlTradeResult result = {0};
   request.action = TRADE_ACTION_DEAL;
   request.type = ORDER_TYPE_BUY;
   request.symbol = Symbol();
   request.volume = lot;
   request.price = price;
   request.tp = price + tpPip/ 10000;
   request.sl = price - slPip/10000;
   
   OrderSend(request, result);
  }
  void OrderSell(double price, double tpPip, double slPip, double lot){
     MqlTradeRequest request = {0};
   MqlTradeResult result = {0};
   request.action = TRADE_ACTION_DEAL;
   request.type = ORDER_TYPE_SELL;
   request.symbol = Symbol();
   request.volume = lot;
   request.price = price;
   request.tp = price - tpPip/ 10000;
   request.sl = price + slPip/10000;
   
   OrderSend(request, result);
  }
  
  void DeleteLastOrder(){
      ulong order_ticket;
      for(int i= OrdersTotal()-1; i>=0; i--){
         if(order_ticket=OrderGetTicket(i) > 0){
            if(magic_number == OrderGetInteger(ORDER_MAGIC)){
               MqlTradeRequest request = {0};
               MqlTradeResult result = {0};
               request.order = order_ticket;
               request.action = TRADE_ACTION_REMOVE;
               OrderSend(request,result);
                //--- write the server reply to log 
               Print(__FUNCTION__,": ",result.comment," reply code ",result.retcode); 
            }
         }   
      }
   }
  void onTimer(){
      count ++;
  }