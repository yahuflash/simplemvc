package us.sban.simplemvc.view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.formatString;
	
//	[SWF(width="320",height="480",frameRate="60",backgroundColor="#ff2255")]
	public class StarlingApplication extends flash.display.Sprite
	{
		public static var StartSceneClass:Class;
		public static var ShowStats:Boolean = true;
		public static var SimulateMultitouch:Boolean = false;
		public static var EnableErrorChecking:Boolean = false;
		
		[Embed(source="startup.jpg")]
		public static var Background:Class;
		// Startup image for HD screens
		[Embed(source="startupHD.jpg")]
		public static var BackgroundHD:Class;
		
		[Embed(source="BlackoakStd.png")]
		public static var BitmapFontPngClass:Class;
		[Embed(source="BlackoakStd.fnt",mimeType="application/octet-stream")]
		public static var BitmapFontXmlClass:Class;
		public static var BitmapFontName:String="BlackoakStd";
		
		public static var application:StarlingApplication;
		
		public function StarlingApplication()
		{
			super();
			application=this;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			
			iOS = Capabilities.manufacturer.indexOf("iOS") != -1;
			Starling.multitouchEnabled=true; // useful on mobile devices
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			
			// we develop the game in a *fixed* coordinate system of 320x480; the game might 
			// then run on a device with a different resolution; for that case, we zoom the 
			// viewPort to the optimal size for any display and load the optimal textures.
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, gameWidth, gameHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				ScaleMode.SHOW_ALL, iOS);
			scaleFactor = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
			
			assetManager = new AssetManager(scaleFactor);
			this.assetManager.verbose=Capabilities.isDebugger;
			var appDir:File = File.applicationDirectory;
			this.assetManager.enqueue( 
				appDir.resolvePath(formatString("assets/{0}x", scaleFactor))
			);
			
			// While Stage3D is initializing, the screen will be blank. To avoid any flickering, 
			// we display a startup image now and remove it below, when Starling is ready to go.
			// This is especially useful on iOS, where "Default.png" (or a variant) is displayed
			// during Startup. You can create an absolute seamless startup that way.
			// 
			// These are the only embedded graphics in this app. We can't load them from disk,
			// because that can only be done asynchronously - i.e. flickering would return.
			// 
			// Note that we cannot embed "Default.png" (or its siblings), because any embedded
			// files will vanish from the application package, and those are picked up by the OS!
			
			var background:Bitmap = this.getBackgroundBitmap();
//			Background = BackgroundHD = null; // no longer needed!
			
			background.x = viewPort.x;
			background.y = viewPort.y;
			background.width  = viewPort.width;
			background.height = viewPort.height;
			background.smoothing = true;
			addChild(background);
			
			_starling = new Starling(StarlingLoadingScene,stage,viewPort);//null,"auto","baseline"
			//			_starling.viewPort = viewPort;
			//contentScaleFactor === 1
			_starling.stage.stageWidth  = gameWidth;
			_starling.stage.stageHeight = gameHeight;
//			_starling.showStats = ShowStats;
			_starling.simulateMultitouch=SimulateMultitouch;
			_starling.enableErrorChecking = EnableErrorChecking;
			
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, function(e:starling.events.Event):void{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				removeChild(background);
				background=null;
				_starling.start();
			});
		}
		
		public var gameWidth:int = 320;
		public var gameHeight:int = 480;
		public var iOS:Boolean=true;
		public var scaleFactor:int;
		
		public var assetManager:AssetManager;
		protected var _starling:Starling;
		protected var _sceneNavigator:StarlingSceneNavigator;
		
		public function getBackgroundBitmap():Bitmap{
			return scaleFactor == 1 ? new Background() : new BackgroundHD();
		}
		
		public function get sceneNavigator():StarlingSceneNavigator{
			if(!_sceneNavigator) _sceneNavigator = _starling.stage.getChildAt(0) as StarlingSceneNavigator;
			return _sceneNavigator;
		}
		public function showSceneNavigator():void{
			_starling.stage.removeChildAt(0,true);
			_starling.stage.addChild( new StarlingSceneNavigator );
			_starling.showStats = ShowStats;
		}
		
		protected function onContext3DCreate():void{
			TextField.registerBitmapFont( new BitmapFont(Texture.fromBitmap(new BitmapFontPngClass), XML(new BitmapFontXmlClass)) );
			BitmapFontPngClass=null;
			BitmapFontXmlClass=null;
		}
	}
}