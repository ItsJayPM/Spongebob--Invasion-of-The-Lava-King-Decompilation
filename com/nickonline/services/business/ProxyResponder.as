package com.nickonline.services.business
{
   public class ProxyResponder extends AbstractResponder
   {
       
      
      private var proxyOnResult:Function;
      
      private var proxyOnFault:Function;
      
      private var proxyOnUpdate:Function;
      
      private var proxyOnStatus:Function;
      
      public function ProxyResponder(proxyOnResult:Function, proxyOnFault:Function, proxyOnStatus:Function = null)
      {
         super();
         this.proxyOnResult = proxyOnResult;
         this.proxyOnFault = proxyOnFault;
         this.proxyOnStatus = proxyOnStatus;
      }
      
      override public function onFault(event:Object) : void
      {
         if(this.proxyOnFault != null)
         {
            this.proxyOnFault(event);
         }
      }
      
      override public function onResult(event:Object) : void
      {
         if(this.proxyOnResult != null)
         {
            this.proxyOnResult(event);
         }
      }
      
      override public function onStatus(event:Object) : void
      {
         if(this.proxyOnStatus != null)
         {
            this.proxyOnStatus(event);
         }
      }
      
      override public function invalidate(message:String) : void
      {
         if(!this.allowValidation())
         {
            return;
         }
         trace("ProxyResponder: invalidate: " + message);
      }
   }
}
