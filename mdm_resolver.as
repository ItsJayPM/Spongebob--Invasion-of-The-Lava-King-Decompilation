package
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.DataEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   import flash.net.SharedObject;
   import flash.net.XMLSocket;
   import flash.system.Capabilities;
   import flash.system.fscommand;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.setInterval;
   import mdm.ASYNC;
   import mdm.Browser;
   import mdm.ExtensionsArray;
   import mdm.FTP;
   import mdm.HTTP;
   import mdm.MediaPlayer;
   import mdm.MediaPlayer6;
   import mdm.Menu;
   import mdm.SYNC;
   
   public dynamic class mdm_resolver extends Proxy
   {
      
      private static var m_doneInit:Boolean = false;
      
      private static var m_properties:Object;
      
      protected static var m_dynMP9:Object = new Object();
      
      private static var m_bHaveEI:Boolean = false;
      
      private static var m_cbID:int = 0;
      
      protected static var m_macSocket:XMLSocket;
      
      protected static var m_dynBrowsers:Object = new Object();
      
      protected static var m_bSimulate:Boolean = false;
      
      private static var m_strURL:String = null;
      
      private static var m_bTestedEI:Boolean = false;
      
      protected static var m_strFormID:String = "!}id}!";
      
      public static var m_spr:Sprite;
      
      protected static var m_events:Object = new Object();
      
      protected static var m_dynMP6:Object = new Object();
      
      protected static var m_macPort:int = -1;
      
      protected static var m_dynHTTP:Object = new Object();
      
      private static var m_cmdCounter:int = 0;
      
      public static var ids:int = 0;
      
      protected static var m_dynFTP:Object = new Object();
       
      
      private var m_strClassName:String = null;
      
      private var strPropsMac:String = "Application<{!!z!!}>path<{z}>string<{z}>ppsv<{z}>Macintosh HD:<{!z!}>pathUnix<{z}>string<{z}>ppsv<{z}>/<{!z!}>openedFilename<{z}>string<{z}>get<{z}><{!z!}>openedFilenameUnix<{z}>string<{z}>get<{z}><{!z!}>filename<{z}>string<{z}>ppsv<{z}>Macintosh HD:Users:<{!z!}>filenameUnix<{z}>string<{z}>ppsv<{z}>/Users/Contents/MacOS/files<{!z!}><{!z!!}>System<{!!z!!}>screenWidth<{z}>string<{z}>ppsv<{z}>1024<{!z!}>screenHeight<{z}>string<{z}>ppsv<{z}>768<{!z!}>localTime<{z}>string<{z}>get<{z}><{!z!}>macVerString<{z}>string<{z}>ppsv<{z}>Mac OS X 10.4.7<{!z!}><{!z!!}>System.Paths<{!!z!!}>fonts<{z}>string<{z}>ppsv<{z}>Macintosh HD:System:Library:Fonts:<{!z!}>desktop<{z}>string<{z}>ppsv<{z}>Macintosh HD:Users:user:Desktop:<{!z!}>temp<{z}>string<{z}>ppsv<{z}>Macintosh HD:private:var:tmp:folders.501:TemporaryItems:<{!z!}>desktopUnix<{z}>string<{z}>ppsv<{z}>/Users/user/Desktop<{!z!}>tempUnix<{z}>string<{z}>ppsv<{z}>/private/var/tmp/folders.501/TemporaryItems<{!z!}>fontsUnix<{z}>string<{z}>ppsv<{z}>/System/Library/Fonts<{!z!}>preferences<{z}>string<{z}>ppsv<{z}>Macintosh HD:Users:user:Library:Preferences:<{!z!}>preferencesUnix<{z}>string<{z}>ppsv<{z}>/Users/user/Library/Preferences<{!z!}><{!z!!}>MacShell<{!!z!!}>exitCode<{z}>string<{z}>get<{z}> <{!z!}>output<{z}>string<{z}>get<{z}> <{!z!}>isRunning<{z}>boolean<{z}>get<{z}> <{!z!}><{!z!!}>AppleScript<{!!z!!}><{!z!!}>Application.Library<{!!z!!}><{!z!!}>Encryption<{!!z!!}><{!z!!}>Network.Mail<{!!z!!}><{!z!!}>Image<{!!z!!}><{!z!!}>Dialogs<{!!z!!}><{!z!!}>Image.ScreenCapture<{!!z!!}><{!z!!}>Database<{!!z!!}><{!z!!}>Database.MySQL<{!!z!!}><{!z!!}>Exception<{!!z!!}><{!z!!}>Input<{!!z!!}><{!z!!}>Input.Mouse<{!!z!!}><{!z!!}>Dialogs.BrowseFolder<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>Dialogs.BrowseFile<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>filterList<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}>creatorCode<{z}>string<{z}>getset<{z}> <{!z!}>buttonText<{z}>string<{z}>getset<{z}> <{!z!}>dialogText<{z}>string<{z}>getset<{z}> <{!z!}>allowMultiple<{z}>boolean<{z}>getset<{z}> <{!z!}><{!z!!}>Dialogs.BrowseFileToSave<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}>creatorCode<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>Menu.Main<{!!z!!}>menuType<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>Network<{!!z!!}>IPAddress<{z}>string<{z}>getset<{z}> <{!z!}>isPresent<{z}>string<{z}>ppsv<{z}>true<{!z!}><{!z!!}>FileSystem<{!!z!!}><{!z!!}>@Browser<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>url<{z}>string<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>true<{!z!}>source<{z}>string<{z}>getset<{z}>0<{!z!}>title<{z}>string<{z}>get<{z}>0<{!z!}>isBusy<{z}>boolean<{z}>get<{z}>false<{!z!}>favorites<{z}>array<{z}>get<{z}>[]<{!z!}>useragent<{z}>string<{z}>set<{z}>0<{!z!}><{!z!!}>@Forms<{!!z!!}>id<{z}>string<{z}>@set<{z}>0<{!z!}>type<{z}>string<{z}>@set<{z}>standard<{!z!}>isCreated<{z}>string<{z}>getset<{!z!}>x<{z}>string<{z}>getset<{!z!}>y<{z}>string<{z}>getset<{!z!}>width<{z}>string<{z}>getset<{!z!}>height<{z}>string<{z}>getset<{!z!}>title<{z}>string<{z}>getset<{!z!}>visible<{z}>boolean<{z}>getset<{!z!}><{!z!!}>@HTTP<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}><{!z!!}>";
      
      protected var m_dynEvents:Object;
      
      private var strProps:String = "Extensions<{!!z!!}><{!z!!}>Extensions.kernel32<{!!z!!}><{!z!!}>GlobalVariables<{!!z!!}><{z}>string<{z}>ppsv<{z}><{!z!}><{!z!!}>@Browser<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>url<{z}>string<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>true<{!z!}>source<{z}>string<{z}>getset<{z}>0<{!z!}>title<{z}>string<{z}>get<{z}>0<{!z!}>isBusy<{z}>boolean<{z}>get<{z}>false<{!z!}>favorites<{z}>array<{z}>get<{z}>[]<{!z!}>useragent<{z}>string<{z}>set<{z}>0<{!z!}><{!z!!}>@ActiveX<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>true<{!z!}><{!z!!}>@MediaPlayer6<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>true<{!z!}>duration<{z}>string<{z}>getset<{z}>0<{!z!}>position<{z}>string<{z}>getset<{z}>0<{!z!}>balance<{z}>string<{z}>getset<{z}>0<{!z!}>volume<{z}>string<{z}>getset<{z}>0<{!z!}>isInstalled<{z}>boolean<{z}>getset<{z}>true<{!z!}>canSeek<{z}>boolean<{z}>getset<{z}>false<{!z!}>canScan<{z}>boolean<{z}>getset<{z}>false<{!z!}><{!z!!}>@MediaPlayer9<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>duration<{z}>string<{z}>getset<{z}>0<{!z!}>position<{z}>string<{z}>getset<{z}>0<{!z!}>currentMarker<{z}>string<{z}>getset<{z}>0<{!z!}>volume<{z}>string<{z}>getset<{z}>0<{!z!}>balance<{z}>string<{z}>getset<{z}>0<{!z!}>markerCount<{z}>string<{z}>getset<{z}>0<{!z!}>source<{z}>string<{z}>getset<{z}>0<{!z!}>mediaName<{z}>string<{z}>getset<{z}>0<{!z!}>mediaWidth<{z}>string<{z}>getset<{z}>0<{!z!}>mediaHeight<{z}>string<{z}>getset<{z}>0<{!z!}>isInstalled<{z}>boolean<{z}>getset<{z}>0<{!z!}>canSeek<{z}>boolean<{z}>getset<{z}>false<{!z!}>canScan<{z}>boolean<{z}>getset<{z}>false<{!z!}><{!z!!}>@QuickTime<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>duration<{z}>string<{z}>getset<{z}>0<{!z!}>position<{z}>string<{z}>getset<{z}>0<{!z!}>isInstalled<{z}>boolean<{z}>getset<{z}>0<{!z!}><{!z!!}>@RealMedia<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>duration<{z}>string<{z}>getset<{z}>0<{!z!}>position<{z}>string<{z}>getset<{z}>0<{!z!}>isInstalled<{z}>boolean<{z}>getset<{z}>0<{!z!}><{!z!!}>@Shockwave<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>bgcolor<{z}>string<{z}>getset<{z}>0<{!z!}>currentFrame<{z}>string<{z}>getset<{z}>0<{!z!}><{!z!!}>@PDF7<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>scrollbars<{z}>string<{z}>getset<{z}>0<{!z!}>toolbar<{z}>string<{z}>getset<{z}>0<{!z!}><{!z!!}>@PDF6<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>scrollbars<{z}>string<{z}>getset<{z}>0<{!z!}>toolbar<{z}>string<{z}>getset<{z}>0<{!z!}><{!z!!}>Application<{!!z!!}>title<{z}>string<{z}>getset<{z}> <{!z!}>isMinimized<{z}>boolean<{z}>get<{z}> <{!z!}>path<{z}>string<{z}>ppsv<{z}>C:\\projects\\fsp2.0\\fsp2.0wrap_newtrans\\<{!z!}>pathUnicode<{z}>string<{z}>ppsv<{z}>C:projects\fsp2.0\fsp2.0wrap_newtrans<{!z!}>filename<{z}>string<{z}>ppsv<{z}>fwrapper.exe<{!z!}>filenameUnicode<{z}>string<{z}>ppsv<{z}>fwrapper.exe<{!z!}><{!z!!}>Application.Screensaver<{!!z!!}><{!z!!}>System<{!!z!!}>localTime<{z}>string<{z}>getset<{z}> <{!z!}>CPUSpeed<{z}>string<{z}>getset<{z}> <{!z!}>RAMSize<{z}>string<{z}>getset<{z}> <{!z!}>screenWidth<{z}>string<{z}>ppsv<{z}>1280<{!z!}>screenHeight<{z}>string<{z}>ppsv<{z}>1024<{!z!}>computerName<{z}>string<{z}>ppsv<{z}>STAV<{!z!}>computerCompany<{z}>string<{z}>ppsv<{z}><{!z!}>computerOwner<{z}>string<{z}>ppsv<{z}> <{!z!}>winVerString<{z}>string<{z}>ppsv<{z}>Windows XP<{!z!}>language<{z}>string<{z}>ppsv<{z}>English (United Kingdom)<{!z!}>winVerStringDetail<{z}>string<{z}>ppsv<{z}>Microsoft Windows XP Professional<{!z!}>osVersion<{z}>string<{z}>getset<{z}> <{!z!}>CDDrive<{z}>string<{z}>getset<{z}> <{!z!}>servicePack<{z}>string<{z}>ppsv<{z}>Service Pack 2<{!z!}>isAdmin<{z}>boolean<{z}>ppsv<{z}>true<{!z!}><{!z!!}>System.Paths<{!!z!!}>programs<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerStart MenuPrograms<{!z!}>programFiles<{z}>string<{z}>ppsv<{z}>C:Program Files<{!z!}>windows<{z}>string<{z}>ppsv<{z}>C:WINDOWS<{!z!}>system<{z}>string<{z}>ppsv<{z}>C:WINDOWSsystem32<{!z!}>temp<{z}>string<{z}>ppsv<{z}>C:DOCUME~1OwnerLOCALS~1Temp<{!z!}>desktop<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerDesktop<{!z!}>personal<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerMy Documents<{!z!}>favorites<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerFavorites<{!z!}>startup<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerStart MenuProgramsStartup<{!z!}>recent<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerRecent<{!z!}>fonts<{z}>string<{z}>ppsv<{z}>C:WINDOWSFonts<{!z!}>history<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerLocal SettingsHistory<{!z!}>cookies<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerCookies<{!z!}>network<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerNetHood<{!z!}>startMenu<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerStart Menu<{!z!}>appData<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerApplication Data<{!z!}>commonAdminTools<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuProgramsAdministrative Tools<{!z!}>commonAppData<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersApplication Data<{!z!}>commonPrograms<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuPrograms<{!z!}>commonStartMenu<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart Menu<{!z!}>commonStartup<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuProgramsStartup<{!z!}>allUsersAppData<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersApplication Data<{!z!}>allUsersPrograms<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuPrograms<{!z!}>allUsersStartMenu<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart Menu<{!z!}>allUsersStartup<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuProgramsStartup<{!z!}><{!z!!}>Dialogs.BrowseFile<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}>filterList<{z}>string<{z}>getset<{z}> <{!z!}>defaultExtension<{z}>string<{z}>getset<{z}> <{!z!}>buttonText<{z}>string<{z}>getset<{z}> <{!z!}>filterText<{z}>string<{z}>getset<{z}> <{!z!}>defaultFilename<{z}>string<{z}>getset<{z}> <{!z!}>allowMultiple<{z}>boolean<{z}>getset<{z}> <{!z!}><{!z!!}>Dialogs<{!z!!}>Dialogs.BrowseFileUnicode<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}>filterList<{z}>string<{z}>getset<{z}> <{!z!}>defaultExtension<{z}>string<{z}>getset<{z}> <{!z!}>defaultFilename<{z}>string<{z}>getset<{z}> <{!z!}>allowMultiple<{z}>boolean<{z}>getset<{z}> <{!z!}><{!z!!}>Menu<{!!z!!}><{!z!!}>Menu.Tray<{!!z!!}>iconHint<{z}>string<{z}>set<{z}> <{!z!}>menuType<{z}>string<{z}>set<{z}> <{!z!}><{!z!!}>Menu.Main<{!!z!!}>menuType<{z}>string<{z}>set<{z}> <{!z!}><{!z!!}>Menu.Context<{!!z!!}>menuType<{z}>string<{z}>set<{z}> <{!z!}><{!z!!}>Database.MySQL<{!!z!!}><{!z!!}>Database<{!!z!!}><{!z!!}>Database.MSAccess<{!!z!!}><{!z!!}>Database.ADO<{!!z!!}><{!z!!}>FileExplorer<{!!z!!}><{!z!!}>FileExplorer.ComboBox<{!!z!!}><{!z!!}>FileExplorer.ListView<{!!z!!}><{!z!!}>FileExplorer.TreeView<{!!z!!}><{!z!!}>Input.Mouse<{!!z!!}><{!z!!}>Input.Joystick<{!!z!!}><{!z!!}>Input.Tablet<{!!z!!}><{!z!!}>String<{!!z!!}><{!z!!}>@DLL<{!!z!!}><{!z!!}>Network<{!!z!!}>IPAddress<{z}>string<{z}>getset<{z}> <{!z!}>isPresent<{z}>string<{z}>ppsv<{z}>true<{!z!}><{!z!!}>Process<{!!z!!}>lastId<{z}>integer<{z}>get<{z}>-1<{!z!}>isOpen<{z}>boolean<{z}>get<{z}>false<{!z!}><{!z!!}>@FTP<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>initialDir<{z}>string<{z}>getset<{z}> <{!z!}>currentDir<{z}>string<{z}>getset<{z}> <{!z!}>isConnected<{z}>boolean<{z}>getset<{z}> <{!z!}>account<{z}>string<{z}>getset<{z}> <{!z!}>async<{z}>boolean<{z}>getset<{z}> <{!z!}>error<{z}>string<{z}>getset<{z}> <{!z!}>success<{z}>boolean<{z}>getset<{z}> <{!z!}>loggerData<{z}>string<{z}>getset<{z}> <{!z!}>isBusy<{z}>boolean<{z}>getset<{z}> <{!z!}>lastReply<{z}>string<{z}>getset<{z}> <{!z!}>noop<{z}>string<{z}>getset<{z}> <{!z!}>passive<{z}>string<{z}>getset<{z}> <{!z!}>serverType<{z}>string<{z}>getset<{z}> <{!z!}>supportsResume<{z}>boolean<{z}>getset<{z}> <{!z!}>timeout<{z}>string<{z}>getset<{z}> <{!z!}>transferMode<{z}>string<{z}>getset<{z}> <{!z!}>transferTime<{z}>string<{z}>getset<{z}> <{!z!}>bytesTransferred<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>@Forms<{!!z!!}>id<{z}>string<{z}>@set<{z}>0<{!z!}>type<{z}>string<{z}>@set<{z}>standard<{!z!}>title<{z}>string<{z}>@set<{!z!}>titleUnicode<{z}>string<{z}>@set<{!z!}>alpha<{z}>number<{z}>getset<{!z!}>baseURL<{z}>string<{z}>getset<{!z!}>bgColor<{z}>string<{z}>getset<{!z!}>isCreated<{z}>boolean<{z}>get<{!z!}>windowState<{z}>string<{z}>getset<{!z!}>x<{z}>string<{z}>getset<{!z!}>y<{z}>string<{z}>getset<{!z!}>width<{z}>string<{z}>getset<{!z!}>height<{z}>string<{z}>getset<{!z!}>visible<{z}>boolean<{z}>getset<{!z!}><{!z!!}>COMPort<{!!z!!}>initialDTR<{z}>string<{z}>getset<{z}>-1<{!z!}>initialRTS<{z}>string<{z}>getset<{z}> <{!z!}>txBuffer<{z}>integer<{z}>set<{z}> <{!z!}>rxBuffer<{z}>integer<{z}>set<{z}> <{!z!}>ports<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>Flash<{!z!!}>FileSystem<{!z!!}>Network.UDP.Socket<{!z!!}>System.DirectX<{!z!!}>Network.Mail<{!z!!}>Dialogs.BrowseFolder<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>System.JScript<{!z!!}>System.VBScript<{!z!!}>Encryption<{!z!!}>Image<{!z!!}>Image.ScreenCapture<{!z!!}>Exception<{!z!!}>Exception.DebugWindow<{!z!!}>Network.UDP.TFTP<{!z!!}>Network.HTTPD<{!z!!}>System.Registry<{!z!!}>Network.TCP.ProxyHTTP<{!z!!}>Clipboard<{!z!!}>Input.Twain<{!z!!}>Application.Library<{!z!!}>Network.TCP.FileServer<{!z!!}>Application.Timer<{!z!!}>Application.Trial<{!!z!!}>usesLeft<{z}>integer<{z}>ppsv<{z}><{!z!}>daysLeft<{z}>integer<{z}>ppsv<{z}><{!z!}>tampered<{z}>boolean<{z}>get<{z}><{!z!}>expired<{z}>boolean<{z}>get<{z}><{!z!}><{!z!!}>FileSystem.BinaryFile<{!z!!}>@HTTP<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}><{!z!!}>";
      
      protected var m_dynamicID:int = -1;
      
      private var alert:MovieClip;
      
      private var m_dynamic:Boolean = false;
      
      protected var m_objs:Object;
      
      public function mdm_resolver()
      {
         m_strClassName = null;
         m_dynamic = false;
         m_dynamicID = -1;
         strProps = "Extensions<{!!z!!}><{!z!!}>Extensions.kernel32<{!!z!!}><{!z!!}>GlobalVariables<{!!z!!}><{z}>string<{z}>ppsv<{z}><{!z!}><{!z!!}>@Browser<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>url<{z}>string<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>true<{!z!}>source<{z}>string<{z}>getset<{z}>0<{!z!}>title<{z}>string<{z}>get<{z}>0<{!z!}>isBusy<{z}>boolean<{z}>get<{z}>false<{!z!}>favorites<{z}>array<{z}>get<{z}>[]<{!z!}>useragent<{z}>string<{z}>set<{z}>0<{!z!}><{!z!!}>@ActiveX<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>true<{!z!}><{!z!!}>@MediaPlayer6<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>true<{!z!}>duration<{z}>string<{z}>getset<{z}>0<{!z!}>position<{z}>string<{z}>getset<{z}>0<{!z!}>balance<{z}>string<{z}>getset<{z}>0<{!z!}>volume<{z}>string<{z}>getset<{z}>0<{!z!}>isInstalled<{z}>boolean<{z}>getset<{z}>true<{!z!}>canSeek<{z}>boolean<{z}>getset<{z}>false<{!z!}>canScan<{z}>boolean<{z}>getset<{z}>false<{!z!}><{!z!!}>@MediaPlayer9<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>duration<{z}>string<{z}>getset<{z}>0<{!z!}>position<{z}>string<{z}>getset<{z}>0<{!z!}>currentMarker<{z}>string<{z}>getset<{z}>0<{!z!}>volume<{z}>string<{z}>getset<{z}>0<{!z!}>balance<{z}>string<{z}>getset<{z}>0<{!z!}>markerCount<{z}>string<{z}>getset<{z}>0<{!z!}>source<{z}>string<{z}>getset<{z}>0<{!z!}>mediaName<{z}>string<{z}>getset<{z}>0<{!z!}>mediaWidth<{z}>string<{z}>getset<{z}>0<{!z!}>mediaHeight<{z}>string<{z}>getset<{z}>0<{!z!}>isInstalled<{z}>boolean<{z}>getset<{z}>0<{!z!}>canSeek<{z}>boolean<{z}>getset<{z}>false<{!z!}>canScan<{z}>boolean<{z}>getset<{z}>false<{!z!}><{!z!!}>@QuickTime<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>duration<{z}>string<{z}>getset<{z}>0<{!z!}>position<{z}>string<{z}>getset<{z}>0<{!z!}>isInstalled<{z}>boolean<{z}>getset<{z}>0<{!z!}><{!z!!}>@RealMedia<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>duration<{z}>string<{z}>getset<{z}>0<{!z!}>position<{z}>string<{z}>getset<{z}>0<{!z!}>isInstalled<{z}>boolean<{z}>getset<{z}>0<{!z!}><{!z!!}>@Shockwave<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>bgcolor<{z}>string<{z}>getset<{z}>0<{!z!}>currentFrame<{z}>string<{z}>getset<{z}>0<{!z!}><{!z!!}>@PDF7<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>scrollbars<{z}>string<{z}>getset<{z}>0<{!z!}>toolbar<{z}>string<{z}>getset<{z}>0<{!z!}><{!z!!}>@PDF6<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>0<{!z!}>scrollbars<{z}>string<{z}>getset<{z}>0<{!z!}>toolbar<{z}>string<{z}>getset<{z}>0<{!z!}><{!z!!}>Application<{!!z!!}>title<{z}>string<{z}>getset<{z}> <{!z!}>isMinimized<{z}>boolean<{z}>get<{z}> <{!z!}>path<{z}>string<{z}>ppsv<{z}>C:\\projects\\fsp2.0\\fsp2.0wrap_newtrans\\<{!z!}>pathUnicode<{z}>string<{z}>ppsv<{z}>C:projects\fsp2.0\fsp2.0wrap_newtrans<{!z!}>filename<{z}>string<{z}>ppsv<{z}>fwrapper.exe<{!z!}>filenameUnicode<{z}>string<{z}>ppsv<{z}>fwrapper.exe<{!z!}><{!z!!}>Application.Screensaver<{!!z!!}><{!z!!}>System<{!!z!!}>localTime<{z}>string<{z}>getset<{z}> <{!z!}>CPUSpeed<{z}>string<{z}>getset<{z}> <{!z!}>RAMSize<{z}>string<{z}>getset<{z}> <{!z!}>screenWidth<{z}>string<{z}>ppsv<{z}>1280<{!z!}>screenHeight<{z}>string<{z}>ppsv<{z}>1024<{!z!}>computerName<{z}>string<{z}>ppsv<{z}>STAV<{!z!}>computerCompany<{z}>string<{z}>ppsv<{z}><{!z!}>computerOwner<{z}>string<{z}>ppsv<{z}> <{!z!}>winVerString<{z}>string<{z}>ppsv<{z}>Windows XP<{!z!}>language<{z}>string<{z}>ppsv<{z}>English (United Kingdom)<{!z!}>winVerStringDetail<{z}>string<{z}>ppsv<{z}>Microsoft Windows XP Professional<{!z!}>osVersion<{z}>string<{z}>getset<{z}> <{!z!}>CDDrive<{z}>string<{z}>getset<{z}> <{!z!}>servicePack<{z}>string<{z}>ppsv<{z}>Service Pack 2<{!z!}>isAdmin<{z}>boolean<{z}>ppsv<{z}>true<{!z!}><{!z!!}>System.Paths<{!!z!!}>programs<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerStart MenuPrograms<{!z!}>programFiles<{z}>string<{z}>ppsv<{z}>C:Program Files<{!z!}>windows<{z}>string<{z}>ppsv<{z}>C:WINDOWS<{!z!}>system<{z}>string<{z}>ppsv<{z}>C:WINDOWSsystem32<{!z!}>temp<{z}>string<{z}>ppsv<{z}>C:DOCUME~1OwnerLOCALS~1Temp<{!z!}>desktop<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerDesktop<{!z!}>personal<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerMy Documents<{!z!}>favorites<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerFavorites<{!z!}>startup<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerStart MenuProgramsStartup<{!z!}>recent<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerRecent<{!z!}>fonts<{z}>string<{z}>ppsv<{z}>C:WINDOWSFonts<{!z!}>history<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerLocal SettingsHistory<{!z!}>cookies<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerCookies<{!z!}>network<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerNetHood<{!z!}>startMenu<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerStart Menu<{!z!}>appData<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsOwnerApplication Data<{!z!}>commonAdminTools<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuProgramsAdministrative Tools<{!z!}>commonAppData<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersApplication Data<{!z!}>commonPrograms<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuPrograms<{!z!}>commonStartMenu<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart Menu<{!z!}>commonStartup<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuProgramsStartup<{!z!}>allUsersAppData<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersApplication Data<{!z!}>allUsersPrograms<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuPrograms<{!z!}>allUsersStartMenu<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart Menu<{!z!}>allUsersStartup<{z}>string<{z}>ppsv<{z}>C:Documents and SettingsAll UsersStart MenuProgramsStartup<{!z!}><{!z!!}>Dialogs.BrowseFile<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}>filterList<{z}>string<{z}>getset<{z}> <{!z!}>defaultExtension<{z}>string<{z}>getset<{z}> <{!z!}>buttonText<{z}>string<{z}>getset<{z}> <{!z!}>filterText<{z}>string<{z}>getset<{z}> <{!z!}>defaultFilename<{z}>string<{z}>getset<{z}> <{!z!}>allowMultiple<{z}>boolean<{z}>getset<{z}> <{!z!}><{!z!!}>Dialogs<{!z!!}>Dialogs.BrowseFileUnicode<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}>filterList<{z}>string<{z}>getset<{z}> <{!z!}>defaultExtension<{z}>string<{z}>getset<{z}> <{!z!}>defaultFilename<{z}>string<{z}>getset<{z}> <{!z!}>allowMultiple<{z}>boolean<{z}>getset<{z}> <{!z!}><{!z!!}>Menu<{!!z!!}><{!z!!}>Menu.Tray<{!!z!!}>iconHint<{z}>string<{z}>set<{z}> <{!z!}>menuType<{z}>string<{z}>set<{z}> <{!z!}><{!z!!}>Menu.Main<{!!z!!}>menuType<{z}>string<{z}>set<{z}> <{!z!}><{!z!!}>Menu.Context<{!!z!!}>menuType<{z}>string<{z}>set<{z}> <{!z!}><{!z!!}>Database.MySQL<{!!z!!}><{!z!!}>Database<{!!z!!}><{!z!!}>Database.MSAccess<{!!z!!}><{!z!!}>Database.ADO<{!!z!!}><{!z!!}>FileExplorer<{!!z!!}><{!z!!}>FileExplorer.ComboBox<{!!z!!}><{!z!!}>FileExplorer.ListView<{!!z!!}><{!z!!}>FileExplorer.TreeView<{!!z!!}><{!z!!}>Input.Mouse<{!!z!!}><{!z!!}>Input.Joystick<{!!z!!}><{!z!!}>Input.Tablet<{!!z!!}><{!z!!}>String<{!!z!!}><{!z!!}>@DLL<{!!z!!}><{!z!!}>Network<{!!z!!}>IPAddress<{z}>string<{z}>getset<{z}> <{!z!}>isPresent<{z}>string<{z}>ppsv<{z}>true<{!z!}><{!z!!}>Process<{!!z!!}>lastId<{z}>integer<{z}>get<{z}>-1<{!z!}>isOpen<{z}>boolean<{z}>get<{z}>false<{!z!}><{!z!!}>@FTP<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>initialDir<{z}>string<{z}>getset<{z}> <{!z!}>currentDir<{z}>string<{z}>getset<{z}> <{!z!}>isConnected<{z}>boolean<{z}>getset<{z}> <{!z!}>account<{z}>string<{z}>getset<{z}> <{!z!}>async<{z}>boolean<{z}>getset<{z}> <{!z!}>error<{z}>string<{z}>getset<{z}> <{!z!}>success<{z}>boolean<{z}>getset<{z}> <{!z!}>loggerData<{z}>string<{z}>getset<{z}> <{!z!}>isBusy<{z}>boolean<{z}>getset<{z}> <{!z!}>lastReply<{z}>string<{z}>getset<{z}> <{!z!}>noop<{z}>string<{z}>getset<{z}> <{!z!}>passive<{z}>string<{z}>getset<{z}> <{!z!}>serverType<{z}>string<{z}>getset<{z}> <{!z!}>supportsResume<{z}>boolean<{z}>getset<{z}> <{!z!}>timeout<{z}>string<{z}>getset<{z}> <{!z!}>transferMode<{z}>string<{z}>getset<{z}> <{!z!}>transferTime<{z}>string<{z}>getset<{z}> <{!z!}>bytesTransferred<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>@Forms<{!!z!!}>id<{z}>string<{z}>@set<{z}>0<{!z!}>type<{z}>string<{z}>@set<{z}>standard<{!z!}>title<{z}>string<{z}>@set<{!z!}>titleUnicode<{z}>string<{z}>@set<{!z!}>alpha<{z}>number<{z}>getset<{!z!}>baseURL<{z}>string<{z}>getset<{!z!}>bgColor<{z}>string<{z}>getset<{!z!}>isCreated<{z}>boolean<{z}>get<{!z!}>windowState<{z}>string<{z}>getset<{!z!}>x<{z}>string<{z}>getset<{!z!}>y<{z}>string<{z}>getset<{!z!}>width<{z}>string<{z}>getset<{!z!}>height<{z}>string<{z}>getset<{!z!}>visible<{z}>boolean<{z}>getset<{!z!}><{!z!!}>COMPort<{!!z!!}>initialDTR<{z}>string<{z}>getset<{z}>-1<{!z!}>initialRTS<{z}>string<{z}>getset<{z}> <{!z!}>txBuffer<{z}>integer<{z}>set<{z}> <{!z!}>rxBuffer<{z}>integer<{z}>set<{z}> <{!z!}>ports<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>Flash<{!z!!}>FileSystem<{!z!!}>Network.UDP.Socket<{!z!!}>System.DirectX<{!z!!}>Network.Mail<{!z!!}>Dialogs.BrowseFolder<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>System.JScript<{!z!!}>System.VBScript<{!z!!}>Encryption<{!z!!}>Image<{!z!!}>Image.ScreenCapture<{!z!!}>Exception<{!z!!}>Exception.DebugWindow<{!z!!}>Network.UDP.TFTP<{!z!!}>Network.HTTPD<{!z!!}>System.Registry<{!z!!}>Network.TCP.ProxyHTTP<{!z!!}>Clipboard<{!z!!}>Input.Twain<{!z!!}>Application.Library<{!z!!}>Network.TCP.FileServer<{!z!!}>Application.Timer<{!z!!}>Application.Trial<{!!z!!}>usesLeft<{z}>integer<{z}>ppsv<{z}><{!z!}>daysLeft<{z}>integer<{z}>ppsv<{z}><{!z!}>tampered<{z}>boolean<{z}>get<{z}><{!z!}>expired<{z}>boolean<{z}>get<{z}><{!z!}><{!z!!}>FileSystem.BinaryFile<{!z!!}>@HTTP<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}><{!z!!}>";
         strPropsMac = "Application<{!!z!!}>path<{z}>string<{z}>ppsv<{z}>Macintosh HD:<{!z!}>pathUnix<{z}>string<{z}>ppsv<{z}>/<{!z!}>openedFilename<{z}>string<{z}>get<{z}><{!z!}>openedFilenameUnix<{z}>string<{z}>get<{z}><{!z!}>filename<{z}>string<{z}>ppsv<{z}>Macintosh HD:Users:<{!z!}>filenameUnix<{z}>string<{z}>ppsv<{z}>/Users/Contents/MacOS/files<{!z!}><{!z!!}>System<{!!z!!}>screenWidth<{z}>string<{z}>ppsv<{z}>1024<{!z!}>screenHeight<{z}>string<{z}>ppsv<{z}>768<{!z!}>localTime<{z}>string<{z}>get<{z}><{!z!}>macVerString<{z}>string<{z}>ppsv<{z}>Mac OS X 10.4.7<{!z!}><{!z!!}>System.Paths<{!!z!!}>fonts<{z}>string<{z}>ppsv<{z}>Macintosh HD:System:Library:Fonts:<{!z!}>desktop<{z}>string<{z}>ppsv<{z}>Macintosh HD:Users:user:Desktop:<{!z!}>temp<{z}>string<{z}>ppsv<{z}>Macintosh HD:private:var:tmp:folders.501:TemporaryItems:<{!z!}>desktopUnix<{z}>string<{z}>ppsv<{z}>/Users/user/Desktop<{!z!}>tempUnix<{z}>string<{z}>ppsv<{z}>/private/var/tmp/folders.501/TemporaryItems<{!z!}>fontsUnix<{z}>string<{z}>ppsv<{z}>/System/Library/Fonts<{!z!}>preferences<{z}>string<{z}>ppsv<{z}>Macintosh HD:Users:user:Library:Preferences:<{!z!}>preferencesUnix<{z}>string<{z}>ppsv<{z}>/Users/user/Library/Preferences<{!z!}><{!z!!}>MacShell<{!!z!!}>exitCode<{z}>string<{z}>get<{z}> <{!z!}>output<{z}>string<{z}>get<{z}> <{!z!}>isRunning<{z}>boolean<{z}>get<{z}> <{!z!}><{!z!!}>AppleScript<{!!z!!}><{!z!!}>Application.Library<{!!z!!}><{!z!!}>Encryption<{!!z!!}><{!z!!}>Network.Mail<{!!z!!}><{!z!!}>Image<{!!z!!}><{!z!!}>Dialogs<{!!z!!}><{!z!!}>Image.ScreenCapture<{!!z!!}><{!z!!}>Database<{!!z!!}><{!z!!}>Database.MySQL<{!!z!!}><{!z!!}>Exception<{!!z!!}><{!z!!}>Input<{!!z!!}><{!z!!}>Input.Mouse<{!!z!!}><{!z!!}>Dialogs.BrowseFolder<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>Dialogs.BrowseFile<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>filterList<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}>creatorCode<{z}>string<{z}>getset<{z}> <{!z!}>buttonText<{z}>string<{z}>getset<{z}> <{!z!}>dialogText<{z}>string<{z}>getset<{z}> <{!z!}>allowMultiple<{z}>boolean<{z}>getset<{z}> <{!z!}><{!z!!}>Dialogs.BrowseFileToSave<{!!z!!}>defaultDirectory<{z}>string<{z}>getset<{z}> <{!z!}>title<{z}>string<{z}>getset<{z}> <{!z!}>creatorCode<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>Menu.Main<{!!z!!}>menuType<{z}>string<{z}>getset<{z}> <{!z!}><{!z!!}>Network<{!!z!!}>IPAddress<{z}>string<{z}>getset<{z}> <{!z!}>isPresent<{z}>string<{z}>ppsv<{z}>true<{!z!}><{!z!!}>FileSystem<{!!z!!}><{!z!!}>@Browser<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}>width<{z}>integer<{z}>getset<{z}>300<{!z!}>height<{z}>integer<{z}>getset<{z}>200<{!z!}>x<{z}>integer<{z}>getset<{z}>0<{!z!}>y<{z}>integer<{z}>getset<{z}>0<{!z!}>url<{z}>string<{z}>getset<{z}>0<{!z!}>visible<{z}>boolean<{z}>getset<{z}>true<{!z!}>source<{z}>string<{z}>getset<{z}>0<{!z!}>title<{z}>string<{z}>get<{z}>0<{!z!}>isBusy<{z}>boolean<{z}>get<{z}>false<{!z!}>favorites<{z}>array<{z}>get<{z}>[]<{!z!}>useragent<{z}>string<{z}>set<{z}>0<{!z!}><{!z!!}>@Forms<{!!z!!}>id<{z}>string<{z}>@set<{z}>0<{!z!}>type<{z}>string<{z}>@set<{z}>standard<{!z!}>isCreated<{z}>string<{z}>getset<{!z!}>x<{z}>string<{z}>getset<{!z!}>y<{z}>string<{z}>getset<{!z!}>width<{z}>string<{z}>getset<{!z!}>height<{z}>string<{z}>getset<{!z!}>title<{z}>string<{z}>getset<{!z!}>visible<{z}>boolean<{z}>getset<{!z!}><{!z!!}>@HTTP<{!!z!!}>id<{z}>integer<{z}>set<{z}>-1<{!z!}><{!z!!}>";
         super();
         m_objs = new Object();
         m_dynEvents = new Object();
      }
      
      private static function OnEvent(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:FTP = null;
         var _loc12_:Browser = null;
         var _loc13_:HTTP = null;
         var _loc14_:MediaPlayer6 = null;
         var _loc15_:MediaPlayer = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc19_:Array = null;
         _loc2_ = m_doneInit;
         _loc6_ = (_loc5_ = (_loc4_ = param1).split("!}}v{}!"))[0];
         if(_loc5_.length)
         {
            _loc5_.shift();
         }
         _loc7_ = false;
         _loc8_ = "";
         _loc9_ = 0;
         _loc10_ = new Object();
         if(_loc6_.substr(0,5) == "onFTP")
         {
            _loc7_ = true;
            if(_loc5_.length)
            {
               _loc9_ = _loc5_.shift();
            }
            if(_loc9_ >= 0)
            {
               _loc8_ = "on" + _loc6_.slice(5);
               if((_loc11_ = m_dynFTP[_loc9_]) != null)
               {
                  if(_loc11_.internal_resolver().m_dynEvents[_loc8_] != null)
                  {
                     _loc11_.internal_resolver().m_dynEvents[_loc8_]();
                  }
               }
            }
         }
         else if(_loc6_.substr(0,9) == "onBrowser")
         {
            _loc7_ = true;
            if(_loc5_.length)
            {
               _loc9_ = _loc5_.shift();
            }
            if(_loc9_ >= 0)
            {
               _loc8_ = "on" + _loc6_.slice(9);
               if((_loc12_ = m_dynBrowsers[_loc9_]) != null)
               {
                  if(_loc12_.internal_resolver().m_dynEvents[_loc8_] != null)
                  {
                     if(_loc8_ == "onDocumentComplete")
                     {
                        _loc10_["url"] = _loc5_[0];
                        _loc12_.internal_resolver().m_dynEvents[_loc8_](_loc10_);
                     }
                  }
               }
            }
         }
         else if(_loc6_.substr(0,6) == "onHTTP")
         {
            _loc7_ = true;
            if(_loc5_.length)
            {
               _loc9_ = _loc5_.shift();
            }
            if(_loc9_ >= 0)
            {
               _loc8_ = "on" + _loc6_.slice(6);
               if((_loc13_ = m_dynHTTP[_loc9_]) != null)
               {
                  if(_loc13_.internal_resolver().m_dynEvents[_loc8_] != null)
                  {
                     if(_loc8_ == "onBinaryTransferComplete")
                     {
                        _loc10_["filename"] = _loc5_[0];
                        _loc13_.internal_resolver().m_dynEvents[_loc8_](_loc10_);
                     }
                     else if(_loc8_ == "onError")
                     {
                        _loc13_.internal_resolver().m_dynEvents[_loc8_]();
                     }
                     else if(_loc8_ == "onProgress")
                     {
                        _loc10_["bytesTotal"] = _loc5_[0];
                        _loc10_["bytesTransferred"] = _loc5_[1];
                        _loc13_.internal_resolver().m_dynEvents[_loc8_](_loc10_);
                     }
                     else if(_loc8_ == "onTransferComplete")
                     {
                        _loc10_["data"] = _loc5_[0];
                        _loc13_.internal_resolver().m_dynEvents[_loc8_](_loc10_);
                     }
                  }
               }
            }
         }
         else if(_loc6_.substr(0,6) == "onWMP6")
         {
            _loc7_ = true;
            if(_loc5_.length)
            {
               _loc9_ = _loc5_.shift();
            }
            if(_loc9_ >= 0)
            {
               _loc8_ = _loc6_;
               if((_loc14_ = m_dynMP6[_loc9_]) != null)
               {
                  if(_loc14_.internal_resolver().m_dynEvents[_loc8_] != null)
                  {
                     if(_loc8_ == "onMPChangeState")
                     {
                        _loc10_["oldState"] = _loc5_[0];
                        _loc10_["newState"] = _loc5_[1];
                        _loc14_.internal_resolver().m_dynEvents[_loc8_](_loc10_);
                     }
                  }
               }
            }
         }
         else if(_loc6_.substr(0,5) == "onWMP")
         {
            _loc7_ = true;
            if(_loc5_.length)
            {
               _loc9_ = _loc5_.shift();
            }
            if(_loc9_ >= 0)
            {
               _loc8_ = _loc6_;
               if((_loc15_ = m_dynMP9[_loc9_]) != null)
               {
                  if(_loc15_.internal_resolver().m_dynEvents[_loc8_] != null)
                  {
                     if(_loc8_ == "onWMPBuffering")
                     {
                        _loc10_["status"] = _loc5_[0];
                        _loc15_.internal_resolver().m_dynEvents[_loc8_](_loc10_);
                     }
                     else if(_loc8_ == "onWMPChangeState")
                     {
                        _loc10_["newState"] = _loc5_[0];
                        _loc15_.internal_resolver().m_dynEvents[_loc8_](_loc10_);
                     }
                     else if(_loc8_ == "onWMPError")
                     {
                        _loc10_["error"] = _loc5_[0];
                        _loc15_.internal_resolver().m_dynEvents[_loc8_](_loc10_);
                     }
                     else if(_loc8_ == "onWMPPositionChanged")
                     {
                        _loc10_["newPosition"] = _loc5_[0];
                        _loc15_.internal_resolver().m_dynEvents[_loc8_](_loc10_);
                     }
                  }
               }
            }
         }
         if(!_loc7_)
         {
            _loc8_ = _loc6_;
            if(_loc6_.substr(0,11) == "onMenuClick")
            {
               if(m_events[_loc8_] != null)
               {
                  m_events[_loc8_]();
               }
            }
            else if(_loc6_.substr(0,18) == "onContextMenuClick")
            {
               if(m_events[_loc8_] != null)
               {
                  m_events[_loc8_]();
               }
            }
            else if(_loc6_.substr(0,15) == "onTrayMenuClick")
            {
               if(m_events[_loc8_] != null)
               {
                  m_events[_loc8_]();
               }
            }
            if(_loc6_.substr(0,6) == "onForm")
            {
               if(_loc8_ == "onFormChangeFocus")
               {
                  _loc3_ = _loc5_.shift();
                  _loc10_["status"] = _loc5_[0];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
               else if(_loc8_ == "onFormClose")
               {
                  _loc3_ = _loc5_.shift();
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_]();
                  }
               }
               else if(_loc8_ == "onFormMaximize")
               {
                  _loc3_ = _loc5_.shift();
                  _loc10_["clientWidth"] = _loc5_[0];
                  _loc10_["clientHeight"] = _loc5_[1];
                  _loc10_["width"] = _loc5_[2];
                  _loc10_["height"] = _loc5_[3];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
               else if(_loc8_ == "onFormMinimize")
               {
                  _loc3_ = _loc5_.shift();
                  _loc10_["clientWidth"] = _loc5_[0];
                  _loc10_["clientHeight"] = _loc5_[1];
                  _loc10_["width"] = _loc5_[2];
                  _loc10_["height"] = _loc5_[3];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
               else if(_loc8_ == "onFormReposition")
               {
                  _loc3_ = _loc5_.shift();
                  _loc10_["x"] = _loc5_[0];
                  _loc10_["y"] = _loc5_[1];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
               else if(_loc8_ == "onFormResize")
               {
                  _loc3_ = _loc5_.shift();
                  _loc10_["clientWidth"] = _loc5_[0];
                  _loc10_["clientHeight"] = _loc5_[1];
                  _loc10_["width"] = _loc5_[2];
                  _loc10_["height"] = _loc5_[3];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
               else if(_loc8_ == "onFormRestore")
               {
                  _loc3_ = _loc5_.shift();
                  _loc10_["clientWidth"] = _loc5_[0];
                  _loc10_["clientHeight"] = _loc5_[1];
                  _loc10_["width"] = _loc5_[2];
                  _loc10_["height"] = _loc5_[3];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
            }
            else if(_loc8_ == "onAppExit" || _loc8_ == "onAppMinimize" || _loc8_ == "onAppRestore" || _loc8_ == "onBottomHit" || _loc8_ == "onLeftHit" || _loc8_ == "onRightHit" || _loc8_ == "onSplashClosed" || _loc8_ == "onTopHit")
            {
               if(m_events[_loc8_] != null)
               {
                  m_events[_loc8_]();
               }
            }
            else if(_loc8_.substr(0,10) == "onAppTimer")
            {
               _loc16_ = "onTimer" + _loc8_.substr(10);
               if(m_events[_loc16_] != null)
               {
                  m_events[_loc16_]();
               }
            }
            else if(_loc8_ == "AppExit")
            {
               if(m_events["onAppExit"] != null)
               {
                  m_events["onAppExit"]();
               }
            }
            else if(_loc8_ == "onArrowKeyPress")
            {
               _loc10_["status"] = _loc5_[0];
               if(m_events[_loc8_] != null)
               {
                  m_events[_loc8_](_loc10_);
               }
            }
            else if(_loc8_ == "onAppChangeFocus")
            {
               _loc10_["focus"] = _loc5_[0];
               if(m_events[_loc8_] != null)
               {
                  m_events[_loc8_](_loc10_);
               }
            }
            else if(_loc8_ == "onDragDrop")
            {
               _loc19_ = (_loc18_ = (_loc17_ = param1).split("!}}v{}!"))[1].split("|");
               _loc10_["files"] = _loc19_;
               if(m_events[_loc8_] != null)
               {
                  m_events[_loc8_](_loc10_);
               }
               _loc10_["files"] = null;
            }
            else if(_loc8_ == "onMDMScriptException")
            {
               _loc10_["formType"] = _loc5_[0];
               _loc10_["command"] = _loc5_[1];
               _loc10_["message"] = _loc5_[2];
               _loc10_["frameNumber"] = _loc5_[3];
               _loc10_["parameter"] = _loc5_[4];
               _loc10_["value"] = _loc5_[5];
               if(m_events[_loc8_] != null)
               {
                  m_events[_loc8_](_loc10_);
               }
            }
            else if(_loc6_.substr(0,5) == "onCOM")
            {
               if(_loc8_ == "onCOMPortCTSChanged")
               {
                  _loc10_["timeCode"] = _loc5_[0];
                  _loc10_["state"] = _loc5_[1];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
               else if(_loc8_ == "onCOMPortDSRChanged")
               {
                  _loc10_["timeCode"] = _loc5_[0];
                  _loc10_["state"] = _loc5_[1];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
               else if(_loc8_ == "onCOMPortData")
               {
                  _loc10_["timeCode"] = _loc5_[0];
                  _loc10_["data"] = _loc5_[1];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
               else if(_loc8_ == "onCOMPortHEXData")
               {
                  _loc10_["timeCode"] = _loc5_[0];
                  _loc10_["hexData"] = _loc5_[1];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
               else if(_loc8_ == "onCOMPortDataSent")
               {
                  _loc10_["timeCode"] = _loc5_[0];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
               else if(_loc8_ == "onCOMPortError")
               {
                  _loc10_["timeCode"] = _loc5_[0];
                  _loc10_["error"] = _loc5_[1];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
               else if(_loc8_ == "onCOMPortSendProgress")
               {
                  _loc10_["timeCode"] = _loc5_[0];
                  _loc10_["bytes"] = _loc5_[1];
                  if(m_events[_loc8_] != null)
                  {
                     m_events[_loc8_](_loc10_);
                  }
               }
            }
            else if(_loc8_ == "onFileListViewDblClick")
            {
               _loc10_["type"] = _loc5_[0];
               _loc10_["name"] = _loc5_[1];
               _loc10_["association"] = _loc5_[2];
               if(m_events[_loc8_] != null)
               {
                  m_events[_loc8_](_loc10_);
               }
            }
            else if(_loc8_ == "onJoystick1ButtonDown" || _loc8_ == "onJoystick1Move" || _loc8_ == "onJoystick2ButtonDown" || _loc8_ == "onJoystick2Move")
            {
               _loc10_["x"] = _loc5_[0];
               _loc10_["y"] = _loc5_[1];
               _loc10_["b1"] = _loc5_[2];
               _loc10_["b2"] = _loc5_[3];
               _loc10_["b3"] = _loc5_[4];
               _loc10_["b4"] = _loc5_[5];
               if(m_events[_loc8_] != null)
               {
                  m_events[_loc8_](_loc10_);
               }
            }
            else if(_loc8_ == "onTabletEvent")
            {
               _loc10_["x"] = _loc5_[0];
               _loc10_["y"] = _loc5_[1];
               _loc10_["pressure"] = _loc5_[2];
               _loc10_["buttons"] = _loc5_[3];
               if(m_events[_loc8_] != null)
               {
                  m_events[_loc8_](_loc10_);
               }
            }
            else if(_loc8_ == "onRequest")
            {
               _loc10_["document"] = _loc5_[0];
               _loc10_["parameters"] = _loc5_[1];
               _loc10_["remoteIP"] = _loc5_[2];
               if(m_events[_loc8_] != null)
               {
                  m_events[_loc8_](_loc10_);
               }
            }
            else if(_loc6_.substr(0,5) == "onUDP")
            {
               if(_loc8_ == "onUDPSocketData")
               {
                  _loc10_["data"] = _loc5_[0];
                  if(m_events["onData"] != null)
                  {
                     m_events["onData"](_loc10_);
                  }
               }
            }
            else if(_loc6_.substr(0,5) == "onTCP")
            {
               if(_loc8_ == "onTCPSocketData")
               {
                  _loc10_["data"] = _loc5_[0];
                  if(m_events["onSocketData"] != null)
                  {
                     m_events["onSocketData"](_loc10_);
                  }
               }
               else if(_loc8_ == "onTCPSocketConnect")
               {
                  if(m_events["onSocketConnect"] != null)
                  {
                     m_events["onSocketConnect"]();
                  }
               }
               else if(_loc8_ == "onTCPSocketClose")
               {
                  if(m_events["onSocketClose"] != null)
                  {
                     m_events["onSocketClose"]();
                  }
               }
            }
         }
         _loc10_ = null;
      }
      
      public static function AssocURL(param1:String) : void
      {
         m_strURL = param1;
      }
      
      public static function InitCallbacks() : void
      {
         ExternalInterface.addCallback("MDMAS3EVENTCALLBACK",eventCallback);
      }
      
      public static function eventCallback(param1:String) : void
      {
         OnEvent(param1);
      }
      
      private function InitialiseObject(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         _loc2_ = param1.split("<{!!z!!}>");
         _loc3_ = _loc2_[0];
         _loc4_ = m_properties;
         _loc5_ = _loc3_.charAt(0) == "@" ? 1 : 0;
         _loc6_ = String("mdm." + _loc3_.substring(_loc5_));
         if(_loc3_.substring(0,11) == "Extensions.")
         {
            ExtensionsArray.push(_loc3_.slice(11));
         }
         else
         {
            m_properties[_loc6_] = new Array();
            if(_loc2_[1] != null)
            {
               _loc7_ = _loc2_[1].split("<{!z!}>");
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  m_properties[_loc6_][_loc8_] = _loc7_[_loc8_].split("<{z}>");
                  _loc8_++;
               }
            }
         }
      }
      
      private function Deserialise(param1:String) : *
      {
         var index:int = 0;
         var ch:String = null;
         var GetNextChar:Function = null;
         var TrimWhiteSpace:Function = null;
         var DeserialiseString:Function = null;
         var DeserialiseArray:Function = null;
         var DeserialiseObject:Function = null;
         var DeserialiseNumber:Function = null;
         var DeserialiseDate:Function = null;
         var DeserialiseXML:Function = null;
         var DeserialiseBoolean:Function = null;
         var DeserialiseValue:Function = null;
         var strInput:String = param1;
         GetNextChar = function():String
         {
            ch = strInput.charAt(index);
            index += 1;
            return ch;
         };
         TrimWhiteSpace = function():void
         {
            while(ch)
            {
               if(ch <= " ")
               {
                  GetNextChar();
               }
               else
               {
                  if(ch != "/")
                  {
                     break;
                  }
                  switch(GetNextChar())
                  {
                     case "/":
                        while(GetNextChar() && ch != "\n" && ch != "\r")
                        {
                        }
                        break;
                     case "*":
                        GetNextChar();
                        while(true)
                        {
                           if(ch)
                           {
                              if(ch == "*")
                              {
                                 if(GetNextChar() == "/")
                                 {
                                    break;
                                 }
                              }
                              else
                              {
                                 GetNextChar();
                              }
                           }
                        }
                        GetNextChar();
                  }
               }
            }
         };
         DeserialiseString = function():String
         {
            var _loc1_:int = 0;
            var _loc2_:String = null;
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            var _loc5_:Boolean = false;
            _loc2_ = "";
            _loc5_ = false;
            if(ch == "\"")
            {
               while(GetNextChar())
               {
                  if(index == strInput.length || ch == "\"")
                  {
                     if(ch == "\"")
                     {
                        GetNextChar();
                     }
                     return _loc2_.split("@q@").join("\"");
                  }
                  _loc2_ += ch;
               }
            }
            return new String();
         };
         DeserialiseArray = function():Array
         {
            var _loc1_:Array = null;
            _loc1_ = [];
            if(ch == "[")
            {
               GetNextChar();
               TrimWhiteSpace();
               if(ch == "]")
               {
                  GetNextChar();
                  return _loc1_;
               }
               while(ch)
               {
                  _loc1_.push(DeserialiseValue());
                  TrimWhiteSpace();
                  if(ch == "]")
                  {
                     GetNextChar();
                     return _loc1_;
                  }
                  if(ch != ",")
                  {
                     break;
                  }
                  GetNextChar();
                  TrimWhiteSpace();
               }
            }
            return new Array();
         };
         DeserialiseObject = function():Object
         {
            var _loc1_:String = null;
            var _loc2_:Object = null;
            _loc2_ = {};
            if(ch == "{")
            {
               GetNextChar();
               TrimWhiteSpace();
               if(ch == "}")
               {
                  GetNextChar();
                  return _loc2_;
               }
               while(ch)
               {
                  _loc1_ = DeserialiseString();
                  TrimWhiteSpace();
                  if(ch != ":")
                  {
                     break;
                  }
                  GetNextChar();
                  _loc2_[_loc1_] = DeserialiseValue();
                  TrimWhiteSpace();
                  if(ch == "}")
                  {
                     GetNextChar();
                     return _loc2_;
                  }
                  if(ch != ",")
                  {
                     break;
                  }
                  GetNextChar();
                  TrimWhiteSpace();
               }
            }
            return new Object();
         };
         DeserialiseNumber = function():Number
         {
            var _loc1_:* = null;
            var _loc2_:Number = NaN;
            _loc1_ = "";
            if(ch == "-")
            {
               _loc1_ = "-";
               GetNextChar();
            }
            while(ch >= "0" && ch <= "9")
            {
               _loc1_ += ch;
               GetNextChar();
            }
            if(ch == ".")
            {
               _loc1_ += ".";
               while(GetNextChar() && ch >= "0" && ch <= "9")
               {
                  _loc1_ += ch;
               }
            }
            _loc2_ = Number(_loc1_);
            if(!isFinite(_loc2_))
            {
               return Number(0);
            }
            return Number(_loc2_);
         };
         DeserialiseDate = function():Date
         {
            var _loc1_:String = null;
            _loc1_ = "";
            if(ch == "#")
            {
               while(GetNextChar())
               {
                  if(ch == "#")
                  {
                     GetNextChar();
                     return new Date(parseInt(_loc1_));
                  }
                  _loc1_ += ch;
               }
            }
            return new Date();
         };
         DeserialiseXML = function():XML
         {
            var _loc1_:String = null;
            var _loc2_:int = 0;
            _loc1_ = "";
            if(ch == "<")
            {
               GetNextChar();
               GetNextChar();
               _loc2_ = strInput.indexOf("</*>");
               while(GetNextChar())
               {
                  if(index == _loc2_ - 1)
                  {
                     while(index < _loc2_ + 5)
                     {
                        GetNextChar();
                     }
                     return new XML(_loc1_);
                  }
                  _loc1_ += ch;
               }
            }
            return new XML();
         };
         DeserialiseBoolean = function():*
         {
            switch(ch)
            {
               case "t":
                  if(GetNextChar() == "r" && GetNextChar() == "u" && GetNextChar() == "e")
                  {
                     GetNextChar();
                     return true;
                  }
                  break;
               case "f":
                  if(GetNextChar() == "a" && GetNextChar() == "l" && GetNextChar() == "s" && GetNextChar() == "e")
                  {
                     GetNextChar();
                     return false;
                  }
                  break;
               case "n":
                  if(GetNextChar() == "u" && GetNextChar() == "l" && GetNextChar() == "l")
                  {
                     GetNextChar();
                     return null;
                  }
                  break;
            }
            return "";
         };
         DeserialiseValue = function():*
         {
            TrimWhiteSpace();
            switch(ch)
            {
               case "{":
                  return DeserialiseObject();
               case "[":
                  return DeserialiseArray();
               case "\"":
                  return DeserialiseString();
               case "-":
                  return DeserialiseNumber();
               case "#":
                  return DeserialiseDate();
               case "<":
                  return DeserialiseXML();
               default:
                  return ch >= "0" && ch <= "9" ? DeserialiseNumber() : DeserialiseBoolean();
            }
         };
         index = 0;
         ch = " ";
         return DeserialiseValue();
      }
      
      protected function SetClassName(param1:String) : void
      {
         m_strClassName = param1;
      }
      
      private function SendCmdMac(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:SharedObject = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:String = null;
         if(GetHostPlatform() == "Mac")
         {
            _loc2_ = "xppcmd";
            _loc3_ = "s000000000000";
            _loc4_ = ++m_cmdCounter;
            _loc5_ = param1 + _loc4_.toString();
            _loc6_ = 64000;
            _loc7_ = Math.round(_loc5_.length / _loc6_) + 1;
            _loc8_ = SharedObject.getLocal(_loc2_,"/",false);
            _loc9_ = _loc7_.toString();
            _loc8_.data.v = "\r";
            _loc8_.data.v += "s000000000000";
            _loc8_.data.v += "\x02";
            _loc8_.data.v += "\x00";
            _loc8_.data.v += "\x01";
            _loc8_.data.v += _loc7_.toString();
            _loc8_.data.v += "\x00";
            _loc8_.data.v += "\x00";
            _loc8_.data.v += "\r";
            _loc10_ = 1;
            while(_loc10_ <= _loc7_)
            {
               _loc11_ = _loc10_.toString();
               while(_loc11_.length < 3)
               {
                  _loc11_ = "0" + _loc11_;
               }
               _loc12_ = String(_loc5_.substr((_loc10_ - 1) * _loc6_,_loc6_));
               _loc8_.data.v += "s" + _loc11_ + "000000000";
               _loc8_.data.v += "\x02";
               _loc8_.data.v += "ú";
               _loc8_.data.v += "\x00";
               _loc8_.data.v += _loc12_;
               _loc10_++;
            }
            _loc8_.flush();
         }
      }
      
      protected function GetClassName() : String
      {
         return m_strClassName;
      }
      
      protected function GetHostPlatform() : String
      {
         return Capabilities.os.substring(0,3);
      }
      
      protected function IsDynamic() : Boolean
      {
         return m_dynamic;
      }
      
      protected function AddEvent(param1:String, param2:Boolean) : void
      {
         m_events[param1] = !!param2 ? dummyCBParams : dummyCB;
      }
      
      private function WorkOutFormID() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         _loc1_ = null;
         if(m_strURL != null)
         {
            _loc1_ = m_strURL;
         }
         if(_loc1_ != null)
         {
            if(GetHostPlatform() == "Win")
            {
               _loc2_ = _loc1_.split("~swd");
               if(_loc2_.length == 2)
               {
                  _loc1_ = _loc2_[1];
                  _loc2_ = _loc1_.split(".");
                  if(_loc2_.length == 2)
                  {
                     _loc3_ = _loc2_[0].valueOf() - 1;
                     m_strFormID = _loc3_.toString();
                     while(m_strFormID.length < 6)
                     {
                        m_strFormID = "0" + m_strFormID;
                     }
                  }
               }
            }
            else if(GetHostPlatform() == "Mac")
            {
               _loc2_ = _loc1_.split("/");
               if(_loc2_.length)
               {
                  _loc1_ = _loc2_[_loc2_.length - 1];
                  _loc2_ = _loc1_.split(".");
                  if(_loc2_.length == 2)
                  {
                     _loc3_ = _loc2_[0].valueOf() - 1;
                     m_strFormID = _loc3_.toString();
                     while(m_strFormID.length < 6)
                     {
                        m_strFormID = "0" + m_strFormID;
                     }
                  }
               }
            }
         }
      }
      
      protected function SetDynamic(param1:int) : void
      {
         m_dynamic = true;
         m_dynamicID = param1;
      }
      
      private function SetupRealBasicSocket() : void
      {
         var onConnect:Function = null;
         var onClose:Function = null;
         var onData:Function = null;
         var onSecurityError:Function = null;
         var onIOError:Function = null;
         m_macPort = 50000 + int(m_strFormID);
         m_macSocket = new XMLSocket();
         onConnect = function(param1:Event):void
         {
         };
         onClose = function(param1:Event):void
         {
         };
         onData = function(param1:DataEvent):void
         {
            var _loc2_:Array = null;
            var _loc3_:Array = null;
            var _loc4_:String = null;
            _loc2_ = param1.data.split("!}}^{}!");
            if(_loc2_[0] == "mdm.__callFunction")
            {
               _loc3_ = _loc2_[1].split("!}}v{}!");
               if(_loc3_[0] != "mdm.__dispatchEvent")
               {
                  _loc4_ = _loc3_.join("!}}v{}!");
                  OnEvent(_loc4_);
               }
               if(GetHostPlatform() == "Mac")
               {
                  if(_loc3_.length > 1 && (_loc3_[0] == "mdm.__dispatchEvent" && _loc3_[1] == "AppExit"))
                  {
                     _loc3_.shift();
                     _loc4_ = _loc3_.join("!}}v{}!");
                     OnEvent(_loc4_);
                  }
               }
            }
         };
         onSecurityError = function(param1:SecurityErrorEvent):void
         {
         };
         onIOError = function(param1:SecurityErrorEvent):void
         {
         };
         m_macSocket.addEventListener(Event.CONNECT,onConnect);
         m_macSocket.addEventListener(Event.CLOSE,onClose);
         m_macSocket.addEventListener(DataEvent.DATA,onData);
         m_macSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
         m_macSocket.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         m_macSocket.connect("127.0.0.1",m_macPort);
      }
      
      protected function AddObject(param1:String, param2:mdm_resolver) : void
      {
         if(param2 == null)
         {
            m_objs[param1] = new mdm_resolver();
            m_objs[param1].m_strClassName = String(m_strClassName + "." + param1);
         }
         else
         {
            m_objs[param1] = param2;
         }
      }
      
      public function ShowMessage(param1:String) : void
      {
         if(m_spr != null)
         {
            alert = new AlertBox(param1);
            m_spr.addChild(alert);
         }
      }
      
      private function HaveEI() : Boolean
      {
         return m_bHaveEI;
      }
      
      protected function CallAsync(param1:String, param2:Array) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         _loc3_ = param2;
         _loc5_ = "";
         if(_loc3_[_loc3_.length - 1] === ASYNC)
         {
            _loc3_.pop();
         }
         _loc6_ = m_strClassName + "." + param1;
         if(IsDynamic())
         {
            _loc5_ = m_dynamicID.toString();
         }
         if((_loc7_ = _loc6_.split("."))[0] == "mdm" && _loc7_[1] == "Forms")
         {
            _loc6_ = _loc7_[0] + "." + _loc7_[1] + "." + _loc7_[3];
            _loc5_ = _loc7_[2];
         }
         if(_loc5_ != "")
         {
            _loc3_.unshift(_loc5_);
         }
         _loc8_ = "mdmCB" + m_cbID.toString();
         m_cbID += 1;
         ExternalInterface.addCallback(_loc8_,_loc3_[_loc3_.length - 1]);
         _loc3_.pop();
         _loc3_.push(_loc8_);
         _loc3_ = esc(_loc3_);
         _loc4_ = !!_loc3_.length ? "\"" + _loc3_.join("\",\"") + "\"" : "";
         if(GetHostPlatform() == "Win" && HaveEI())
         {
            fscommand(_loc6_,_loc4_);
         }
         else if(GetHostPlatform() == "Mac")
         {
         }
      }
      
      protected function CallSyncNoReturn(param1:String, param2:Array) : void
      {
         var _loc3_:* = undefined;
         _loc3_ = CallSync(param1,param2);
      }
      
      protected function CallSync(param1:String, param2:Array) : *
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:* = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         _loc3_ = param2;
         _loc5_ = "";
         if(_loc3_[_loc3_.length - 1] === SYNC)
         {
            _loc3_.pop();
         }
         _loc8_ = m_strClassName + "." + param1;
         if(IsDynamic())
         {
            _loc5_ = m_dynamicID.toString();
         }
         if((_loc9_ = _loc8_.split("."))[0] == "mdm" && _loc9_[1] == "Forms")
         {
            _loc8_ = _loc9_[0] + "." + _loc9_[1] + "." + _loc9_[3];
            _loc5_ = _loc9_[2];
         }
         if(_loc5_ != "")
         {
            _loc3_.unshift(_loc5_);
         }
         if(GetHostPlatform() == "Win" || GetHostPlatform() == "Lin")
         {
            _loc3_ = esc(_loc3_);
            _loc4_ = !!_loc3_.length ? "<{zinc}>" + ("\"" + _loc3_.join("\",\"") + "\"") : "";
         }
         else if(GetHostPlatform() == "Mac")
         {
            if(HaveEI())
            {
               _loc3_ = esc(_loc3_);
               _loc4_ = !!_loc3_.length ? "<{zinc}>" + ("\"" + _loc3_.join("\",\"") + "\"") : "";
            }
            else
            {
               _loc6_ = new Date().getTime() + "<{zinc}>";
               _loc4_ = !!_loc3_.length ? "<{zinc}>" + _loc3_.join("<{zincp}>") : "";
            }
         }
         if((GetHostPlatform() == "Win" || GetHostPlatform() == "Lin") && HaveEI())
         {
            if((_loc7_ = ExternalInterface.call(_loc8_,m_strFormID,_loc4_)) != null)
            {
               return Deserialise(_loc7_);
            }
         }
         else if(GetHostPlatform() == "Mac")
         {
            if(HaveEI())
            {
               if((_loc7_ = ExternalInterface.call(_loc8_,m_strFormID,_loc4_)) != null)
               {
                  return Deserialise(_loc7_);
               }
            }
            else
            {
               SendCmdMac(m_strFormID + "<{zinc}>" + _loc8_ + _loc4_ + "<{zinc}>" + _loc6_);
               if((_loc7_ = WaitReturnMac()) != null)
               {
                  return Deserialise(_loc7_);
               }
            }
         }
         return "";
      }
      
      protected function AddDynamicEvent(param1:String, param2:Boolean) : void
      {
         m_dynEvents[param1] = !!param2 ? dummyCBParams : dummyCB;
      }
      
      private function InitialiseObjects(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         _loc2_ = param1.split("<{!z!!}>");
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            InitialiseObject(_loc2_[_loc3_]);
            _loc3_++;
         }
      }
      
      protected function MakeFormProperties(param1:String) : void
      {
         m_properties[param1] = new Array();
         m_properties[param1] = m_properties["mdm.forms"];
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         if(!m_doneInit)
         {
            return "";
         }
         if(m_objs[param1] != null)
         {
            return m_objs[param1];
         }
         _loc2_ = m_properties[m_strClassName];
         if(_loc2_ == null)
         {
            return "";
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_][0] == param1)
            {
               if(_loc2_[_loc3_][2] == "get" || _loc2_[_loc3_][2] == "getset")
               {
                  _loc4_ = String("get" + param1);
                  _loc5_ = new Array();
                  return CallSync(_loc4_,_loc5_);
               }
               if(_loc2_[_loc3_][2] != "ppsv")
               {
                  break;
               }
               if(_loc2_[_loc3_][1] == "integer")
               {
                  return new int(_loc2_[_loc3_][3]);
               }
               if(_loc2_[_loc3_][1] == "string")
               {
                  return new String(_loc2_[_loc3_][3]);
               }
               if(_loc2_[_loc3_][1] == "boolean")
               {
                  return new Boolean(_loc2_[_loc3_][3]);
               }
            }
            _loc3_++;
         }
         return "";
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         var _loc3_:Array = null;
         if(!m_doneInit)
         {
            return "";
         }
         _loc3_ = rest;
         if(_loc3_[_loc3_.length - 1] !== ASYNC)
         {
            return CallSync(param1,_loc3_);
         }
         return CallAsync(param1,_loc3_);
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         return 0;
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         if(!m_doneInit)
         {
            return;
         }
         _loc3_ = m_properties[m_strClassName];
         if(_loc3_ != null)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_][0] == param1)
               {
                  if(_loc3_[_loc4_][2] == "set" || _loc3_[_loc4_][2] == "getset")
                  {
                     _loc5_ = String("set" + param1);
                     (_loc6_ = new Array()).push(param2);
                     CallSync(_loc5_,_loc6_);
                     break;
                  }
                  break;
               }
               _loc4_++;
            }
         }
         if(m_strClassName == "mdm.Menu.Context")
         {
            if(param1 != "menuType")
            {
               Menu.Context.AddEvent(param1,false);
               Menu.Context.SetEvent(param1,param2);
            }
         }
         else if(m_strClassName == "mdm.Menu.Main")
         {
            if(param1 != "menuType")
            {
               Menu.Main.AddEvent(param1,false);
               Menu.Main.SetEvent(param1,param2);
            }
         }
         else if(m_strClassName == "mdm.Menu.Tray")
         {
            if(param1 != "menuType" && param1 != "iconHint")
            {
               Menu.Tray.AddEvent(param1,false);
               Menu.Tray.SetEvent(param1,param2);
            }
         }
         else if(IsDynamic())
         {
            if(m_dynEvents[param1] != null)
            {
               SetDynamicEvent(param1,param2);
            }
         }
         else if(m_events[param1] != null)
         {
            SetEvent(param1,param2);
         }
      }
      
      private function WriteSO(param1:String) : void
      {
         var _loc2_:SharedObject = null;
         if(GetHostPlatform() == "Mac")
         {
            _loc2_ = SharedObject.getLocal(param1,"/");
            if(_loc2_.data.v != "<init />")
            {
               _loc2_.data.v = "<init />";
            }
            _loc2_.flush();
         }
      }
      
      private function dlm(param1:String, param2:String) : String
      {
         return param1 + "!}}^" + param2 + "^{}!";
      }
      
      protected function mdmSetup() : void
      {
         var strDefs:String = null;
         var strEI:String = null;
         var numProps:int = 0;
         var arr:Array = null;
         var myPattern:RegExp = null;
         var i:int = 0;
         if(!m_doneInit)
         {
            if(!m_bSimulate)
            {
               WorkOutFormID();
            }
            try
            {
               strEI = ExternalInterface.call("mdm.hasEI","");
               if(strEI != null)
               {
                  m_bHaveEI = true;
                  if(m_strFormID == "!}id}!")
                  {
                     if(GetHostPlatform() == "Win")
                     {
                        m_strFormID = strEI;
                     }
                  }
               }
               else if(m_strFormID == "!}id}!")
               {
                  m_strFormID = "000000";
               }
            }
            catch(e:Error)
            {
            }
            if((GetHostPlatform() == "Win" || GetHostPlatform() == "Lin") && HaveEI())
            {
               if(!m_bSimulate)
               {
                  strDefs = ExternalInterface.call("mdm.initialise",m_strFormID,"");
               }
               else
               {
                  strDefs = strProps;
               }
            }
            if(GetHostPlatform() == "Mac")
            {
               if(!m_bSimulate)
               {
                  if(HaveEI())
                  {
                     strDefs = ExternalInterface.call("mdm.initialise",m_strFormID,"");
                  }
               }
               else
               {
                  strDefs = strPropsMac;
               }
            }
            m_properties = new Object();
            if(strDefs != null)
            {
               InitialiseObjects(strDefs);
            }
            if(GetHostPlatform() == "Win")
            {
               if(!m_bSimulate && HaveEI())
               {
                  numProps = m_properties["mdm.System.Paths"].length;
                  arr = m_properties["mdm.System.Paths"];
                  myPattern = /\\\\/g;
                  i = 0;
                  while(i < numProps)
                  {
                     if(arr[i][2] == "ppsv" && arr[i][1] == "string")
                     {
                        arr[i][3] = arr[i][3].replace(myPattern,"\\");
                     }
                     i++;
                  }
                  ExternalInterface.addCallback("MDMAS3EVENTCALLBACK",eventCallback);
                  ExternalInterface.call("mdm.flash9ready",m_strFormID,"");
               }
            }
            if(GetHostPlatform() == "Mac" || GetHostPlatform() == "Lin")
            {
               if(!m_bSimulate && HaveEI())
               {
                  ExternalInterface.call("mdm.flash9ready",m_strFormID,"");
               }
            }
            if((GetHostPlatform() == "Mac" || GetHostPlatform() == "Lin") && HaveEI())
            {
               InitEventsGatherer();
            }
            m_doneInit = true;
         }
      }
      
      private function WaitReturnMac() : String
      {
         var _loc1_:String = null;
         var _loc2_:* = null;
         var _loc3_:String = null;
         var _loc4_:SharedObject = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(GetHostPlatform() == "Mac")
         {
            _loc1_ = "xppres";
            _loc2_ = "s000000000000";
            _loc3_ = "";
            _loc4_ = SharedObject.getLocal(_loc1_ + m_cmdCounter,"/",false);
            _loc5_ = Number(_loc4_.data[_loc2_]) + 1;
            _loc6_ = 1;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc6_.toString();
               while(_loc7_.length < 3)
               {
                  _loc7_ = "0" + _loc7_;
               }
               _loc2_ = "s" + _loc7_ + "000000000";
               _loc3_ += _loc4_.data[_loc2_];
               _loc6_++;
            }
            return _loc3_;
         }
         return "";
      }
      
      private function InitEventsGatherer() : void
      {
         var f:Function = null;
         f = function():void
         {
            var _loc1_:String = null;
            var _loc2_:Array = null;
            var _loc3_:int = 0;
            if((GetHostPlatform() == "Mac" || GetHostPlatform() == "Lin") && HaveEI())
            {
               _loc1_ = ExternalInterface.call("mdm.Application.collectEvents",m_strFormID,"");
               if(_loc1_ != "")
               {
                  _loc2_ = _loc1_.split("!!!{}event{{!!!");
                  if(_loc2_.length > 0)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < _loc2_.length)
                     {
                        OnEvent(_loc2_[_loc3_]);
                        _loc3_++;
                     }
                  }
               }
            }
         };
         setInterval(f,1000 / 20);
      }
      
      private function esc(param1:Array) : Array
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(typeof param1[_loc2_] == "string")
            {
               param1[_loc2_] = param1[_loc2_].split(",").join("@co@").split("\"").join("@dq@").split("&").join("@amp@");
            }
            _loc2_++;
         }
         return param1;
      }
      
      private function Serialise() : void
      {
      }
      
      protected function SetEvent(param1:String, param2:Function) : void
      {
         m_events[param1] = param2;
      }
      
      protected function SetDynamicEvent(param1:String, param2:Function) : void
      {
         m_dynEvents[param1] = param2;
      }
   }
}

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class AlertBox extends MovieClip
{
    
   
   function AlertBox(param1:String)
   {
      var _loc2_:SimpleButton = null;
      var _loc3_:TextField = null;
      var _loc4_:Sprite = null;
      var _loc5_:Sprite = null;
      super();
      _loc2_ = new SimpleButton();
      (_loc4_ = new Sprite()).graphics.lineStyle(2,2105376);
      _loc4_.graphics.beginFill(16711935);
      _loc4_.graphics.drawRect(10,10,300,200);
      (_loc5_ = new Sprite()).graphics.lineStyle(2,2105376);
      _loc5_.graphics.beginFill(16711680);
      _loc5_.graphics.drawRect(10,10,300,200);
      _loc2_.upState = _loc5_;
      _loc2_.overState = _loc5_;
      _loc2_.downState = _loc4_;
      _loc2_.useHandCursor = true;
      _loc2_.hitTestState = _loc5_;
      _loc2_.addEventListener(MouseEvent.CLICK,closeMe);
      addChild(_loc2_);
      _loc3_ = new TextField();
      _loc3_.autoSize = TextFieldAutoSize.LEFT;
      _loc3_.selectable = false;
      _loc3_.textColor = 16777215;
      _loc3_.text = param1;
      _loc3_.x = (_loc2_.width - _loc3_.width) / 2;
      _loc3_.y = (_loc2_.height - _loc3_.height) / 2;
      _loc5_.addChild(_loc3_);
   }
   
   private function closeMe(param1:Event) : void
   {
      param1.currentTarget.parent.removeChild(param1.currentTarget);
   }
}

function dummyCB():void
{
}
function dummyCBParams(param1:Object):void
{
}
import flash.utils.ByteArray;

class Base64
{
   
   private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
   
   function Base64()
   {
      super();
      throw new Error("Base64 class is static container only");
   }
   
   public static function encode(param1:String) : String
   {
      var _loc2_:ByteArray = null;
      _loc2_ = new ByteArray();
      _loc2_.writeUTFBytes(param1);
      return encodeByteArray(_loc2_);
   }
   
   public static function decodeToByteArray(param1:String) : ByteArray
   {
      var _loc2_:ByteArray = null;
      var _loc3_:Array = null;
      var _loc4_:Array = null;
      var _loc5_:uint = 0;
      var _loc6_:uint = 0;
      var _loc7_:uint = 0;
      _loc2_ = new ByteArray();
      _loc3_ = new Array(4);
      _loc4_ = new Array(3);
      _loc5_ = 0;
      while(_loc5_ < param1.length)
      {
         _loc6_ = 0;
         while(_loc6_ < 4 && _loc5_ + _loc6_ < param1.length)
         {
            _loc3_[_loc6_] = BASE64_CHARS.indexOf(param1.charAt(_loc5_ + _loc6_));
            _loc6_++;
         }
         _loc4_[0] = (_loc3_[0] << 2) + ((_loc3_[1] & 48) >> 4);
         _loc4_[1] = ((_loc3_[1] & 15) << 4) + ((_loc3_[2] & 60) >> 2);
         _loc4_[2] = ((_loc3_[2] & 3) << 6) + _loc3_[3];
         _loc7_ = 0;
         while(_loc7_ < _loc4_.length)
         {
            if(_loc3_[_loc7_ + 1] == 64)
            {
               break;
            }
            _loc2_.writeByte(_loc4_[_loc7_]);
            _loc7_++;
         }
         _loc5_ += 4;
      }
      _loc2_.position = 0;
      return _loc2_;
   }
   
   public static function encodeByteArray(param1:ByteArray) : String
   {
      var _loc2_:String = null;
      var _loc3_:Array = null;
      var _loc4_:Array = null;
      var _loc5_:uint = 0;
      var _loc6_:uint = 0;
      var _loc7_:uint = 0;
      _loc2_ = "";
      _loc4_ = new Array(4);
      param1.position = 0;
      while(param1.bytesAvailable > 0)
      {
         _loc3_ = new Array();
         _loc5_ = 0;
         while(_loc5_ < 3 && param1.bytesAvailable > 0)
         {
            _loc3_[_loc5_] = param1.readUnsignedByte();
            _loc5_++;
         }
         _loc4_[0] = (_loc3_[0] & 252) >> 2;
         _loc4_[1] = (_loc3_[0] & 3) << 4 | _loc3_[1] >> 4;
         _loc4_[2] = (_loc3_[1] & 15) << 2 | _loc3_[2] >> 6;
         _loc4_[3] = _loc3_[2] & 63;
         _loc6_ = _loc3_.length;
         while(_loc6_ < 3)
         {
            _loc4_[_loc6_ + 1] = 64;
            _loc6_++;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc2_ += BASE64_CHARS.charAt(_loc4_[_loc7_]);
            _loc7_++;
         }
      }
      return _loc2_;
   }
   
   public static function decode(param1:String) : String
   {
      var _loc2_:ByteArray = null;
      _loc2_ = decodeToByteArray(param1);
      return _loc2_.readUTFBytes(_loc2_.length);
   }
}
