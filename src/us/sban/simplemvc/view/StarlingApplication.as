package us.sban.simplemvc.view
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
//	[SWF(width="320",height="480",frameRate="60",backgroundColor="#ff2255")]
	public class StarlingApplication extends flash.display.Sprite
	{
		public static var StartSceneClass:Class;
		public static var ShowStats:Boolean = true;
		
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
			if(stage)
				init();
			else
				addEventListener(flash.events.Event.ADDED_TO_STAGE,
						function(e:flash.events.Event):void{
							e.currentTarget.removeEventListener(e.type, arguments.callee);
							init();
						}
					);
		}
		
		public var gameWidth:int = 640;
		public var gameHeight:int = 960;
		public var assetManager:AssetManager = new AssetManager();
		protected var _starling:Starling;
		
		public function get sceneNavigator():StarlingSceneNavigator{
			return _starling.stage.getChildAt(0) as StarlingSceneNavigator;
		}
		
		protected function onLoadAssetsComplete():void{
			sceneNavigator.replaceScene(new StartSceneClass);
		}
		protected function onContext3DCreate():void{
			assetManager.scaleFactor = _starling.contentScaleFactor;
			TextField.registerBitmapFont( new BitmapFont(Texture.fromBitmap(new BitmapFontPngClass), XML(new BitmapFontXmlClass)) );						
		}
		
		protected function init():void{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			
			Starling.multitouchEnabled=true;
//			this.beforeInit();
			//device width 640 in iphone4+
			var screenWidth:int  = stage.fullScreenWidth;
			var screenHeight:int = stage.fullScreenHeight;
//			trace("screenWidth",screenWidth,stage.stageWidth);
			var viewPort:Rectangle = new Rectangle(0, 0, screenWidth, screenHeight);
			_starling = new Starling(StarlingSceneNavigator,stage,viewPort);//null,"auto","baseline"
//			_starling.viewPort = viewPort;
			//contentScaleFactor === 1
			_starling.stage.stageWidth  = screenWidth;
			_starling.stage.stageHeight = screenHeight;
			_starling.showStats = ShowStats;
			_starling.simulateMultitouch=true;
			_starling.start();
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, function(e:starling.events.Event):void{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				sceneNavigator.replaceScene( new StarlingLoadingScene );
				loadAssets();
			});
			_starling.addEventListener(starling.events.Event.CONTEXT3D_CREATE, function(e:starling.events.Event):void{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				onContext3DCreate();
			});
			_starling.stage.addEventListener(starling.events.Event.RESIZE,function(e:starling.events.Event,size:Point):void{
				/*
				_starling.viewPort = RectangleUtil.fit(
					new Rectangle(0, 0, stage.stageWidth, stage.stageHeight),
					new Rectangle(0, 0, size.x, size.y),
					ScaleMode.SHOW_ALL);
				*/
			});
		}
		
		protected function loadAssets():void{
			//assets.enqueue("http://gamua.com/img/home/starling-flying.jpg");
			//assets.enqueue(EmbeddedAssets);
			this.assetManager.verbose=true;
			this.assetManager.enqueue( File.applicationDirectory.resolvePath("assets") );
			this.assetManager.loadQueue(function(ratio:Number):void{
//				trace("load assets:",ratio);
				(sceneNavigator.currentScene as StarlingLoadingScene).updateProgress(ratio);
				if(ratio == 1){
					onLoadAssetsComplete();
				}
			});
		}
	}
}