package com.nickonline.services.business
{
   public class AbstractResponder implements IResponder
   {
      
      public static const VERSION:String = "1";
       
      
      private var validationEnabled:Boolean = true;
      
      public function AbstractResponder()
      {
         super();
      }
      
      public function allowValidation() : Boolean
      {
         return this.validationEnabled;
      }
      
      public function onFault(event:Object) : void
      {
         throw new Error("AbstractResponder: onResult: Provide a concrete class.");
      }
      
      public function onStatus(event:Object) : void
      {
         throw new Error("AbstractResponder: onResult: Provide a concrete class.");
      }
      
      public function isValid(version:String) : Boolean
      {
         return VERSION == version;
      }
      
      public function onResult(event:Object) : void
      {
         throw new Error("AbstractResponder: onResult: Provide a concrete class.");
      }
      
      public function validate(version:String) : void
      {
         if(!this.allowValidation() || this.isValid(version))
         {
            return;
         }
         this.invalidate("Responder::invalid version: request:[" + AbstractResponder.VERSION + "] - server:[" + version + "]");
      }
      
      public function invalidate(message:String) : void
      {
         if(!this.allowValidation())
         {
            return;
         }
         throw new Error(message);
      }
      
      public function enableValidation(validationEnabled:Boolean) : void
      {
         this.validationEnabled = validationEnabled;
      }
   }
}
