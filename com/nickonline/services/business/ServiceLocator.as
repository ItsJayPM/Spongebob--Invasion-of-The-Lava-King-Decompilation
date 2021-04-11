package com.nickonline.services.business
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public final class ServiceLocator
   {
      
      public static const DEFAULT_MANAGER_URI:String = "/common/flash/services/ServiceManager.swf";
       
      
      private var pManagerURI:String;
      
      private var doServiceLoaded:Function;
      
      private var managerLoader:Loader;
      
      private var serviceEvents:Object;
      
      private var managerLoaderContext:LoaderContext;
      
      private var serviceManager;
      
      private var pConfigURI:String;
      
      private var pDefaultURI:String;
      
      public function ServiceLocator(managerURI:String = null, configURI:String = null)
      {
         super();
         this.managerURI = managerURI;
         this.configURI = configURI;
         this.serviceEvents = null;
      }
      
      private function loaded(event:Event) : void
      {
         if(Event.INIT != event.type)
         {
            if(Event.COMPLETE == event.type)
            {
               this.serviceManager = event.target.content;
               this.serviceManager.defaultURI = this.defaultURI;
               this.addEventToManager("EVENT_SERVICES_LOADED");
               this.addEventToManager("EVENT_SERVICE_INVALID");
               this.addEventToManager("EVENT_SERVICES_NOT_FOUND");
               this.serviceManager.loadServices(this.configURI);
            }
            else
            {
               if(this.serviceEvents == null)
               {
                  return;
               }
               this.serviceEvents["EVENT_SERVICES_NOT_FOUND"](new Event("EVENT_SERVICES_NOT_FOUND"));
            }
         }
      }
      
      public function removeEventListener(type:String, listener:Function) : void
      {
         if(this.serviceManager == null)
         {
            return;
         }
         this.serviceManager.removeEventListener(type,listener);
      }
      
      public function addEventListener(type:String, listener:Function) : void
      {
         if(this.serviceEvents == null)
         {
            this.serviceEvents = new Object();
         }
         this.serviceEvents[type] = listener;
      }
      
      public function get configURI() : String
      {
         return this.pConfigURI;
      }
      
      public function set configURI(configURI:String) : void
      {
         this.pConfigURI = configURI;
      }
      
      public function set defaultURI(defaultURI:String) : void
      {
         this.pDefaultURI = defaultURI;
      }
      
      public function load() : void
      {
         this.managerLoader = new Loader();
         this.managerLoader.contentLoaderInfo.addEventListener(Event.INIT,this.loaded);
         this.managerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loaded);
         this.managerLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loaded);
         this.managerLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loaded);
         this.managerLoaderContext = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
         this.managerLoader.load(new URLRequest(this.defaultURI + this.managerURI),this.managerLoaderContext);
      }
      
      public function get defaultURI() : String
      {
         return this.pDefaultURI == null ? "" : this.pDefaultURI;
      }
      
      public function execute(serviceName:String, method:String, args:Object, responder:*) : void
      {
         this.serviceManager.execute(serviceName,method,args,responder);
      }
      
      public function addEventToManager(type:String) : void
      {
         if(this.serviceManager == null || type == null || this.serviceEvents == null || this.serviceEvents[type] == null)
         {
            return;
         }
         this.serviceManager.addEventListener(type,this.serviceEvents[type]);
      }
      
      public function set managerURI(managerURI:String) : void
      {
         this.pManagerURI = managerURI;
      }
      
      public function get managerURI() : String
      {
         return this.pManagerURI == null ? DEFAULT_MANAGER_URI : this.pManagerURI;
      }
   }
}
