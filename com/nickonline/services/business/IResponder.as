package com.nickonline.services.business
{
   public interface IResponder
   {
       
      
      function onStatus(param1:Object) : void;
      
      function allowValidation() : Boolean;
      
      function onFault(param1:Object) : void;
      
      function validate(param1:String) : void;
      
      function isValid(param1:String) : Boolean;
      
      function invalidate(param1:String) : void;
      
      function enableValidation(param1:Boolean) : void;
      
      function onResult(param1:Object) : void;
   }
}
