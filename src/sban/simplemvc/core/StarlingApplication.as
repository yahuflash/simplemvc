package sban.simplemvc.core
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import feathers.themes.MetalWorksMobileTheme;
	
	import sban.simplemvc.control.StarlingNavigatorControl;
	import sban.simplemvc.model.SimpleModel;
	
	import starling.core.Starling;
	
//	[SWF(frameRate="60", backgroundColor="#000")]
	public class StarlingApplication extends Sprite implements IApplication
	{
		public static function get application():StarlingApplication
		{
			return Application.application as StarlingApplication;
		}
		
		public function StarlingApplication()
		{
			super();
			if(!Application.application)
				Application.application=this;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//[Embed(source="../assets/atlas.png")]
		public var AtlasTexture_Class:Class;
		//[Embed(source="../assets/atlas.xml", mimeType="application/octet-stream")]
		public var AtlasXml_Class:Class;
		public var Theme_Class:Class = MetalWorksMobileTheme;
		
		/** Starling object. */
		public var _starling:Starling;
		public var navigator :StarlingNavigatorControl;
		public var url :QueryString = new QueryString();
		protected var _model :SimpleModel = new SimpleModel();
		protected var controlPool :Pool = new Pool();
		protected var _stack :Stack = new Stack();
		
		public function get stack():Stack
		{
			// TODO Auto Generated method stub
			return _stack;
		}
		
		public function get model():SimpleModel
		{
			// TODO Auto Generated method stub
			return _model;
		}
		
		public function get stageWidth():int
		{
			return _starling.stage.stageWidth;
		}
		public function get stageHeight():int
		{
			return _starling.stage.stageHeight;
		}
		
		public function initVars():void
		{
			//override
		}

		protected function onAddedToStage(event: Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			initVars();
			registerControls();
			
			//开启多点触控
			//Starling.multitouchEnabled = true;
			//在iOS上不开启,如果是android开启
			Starling.handleLostContext = false; 
			
			var screenWidth:int  = stage.fullScreenWidth;
			var screenHeight:int = stage.fullScreenHeight;
//			trace("screenWidth Height:",screenWidth,screenHeight);
			//viewPort决定的是渲染区域，即呈现应用内容的区域
			var viewPort:Rectangle = new Rectangle();
			//对于iphone系统，如何处理iphone5与4的尺寸，是具体应用决定
			viewPort.width = screenWidth;
			viewPort.height = screenHeight;
			
			_starling = new Starling(StarlingNavigatorControl, stage, viewPort, null, "auto", "baseline");
			_starling.stage.stageWidth  = screenWidth;
			_starling.stage.stageHeight = screenHeight;
//			trace("screenWidth Height:",screenWidth,screenHeight);
//			trace("Starling.current.contentScaleFactor",Starling.current.contentScaleFactor);
			
			// Define basic anti aliasing.
			_starling.antiAliasing = 1;
			// Show statistics for memory usage and fps.
			_starling.showStats = true;
			// Position stats.
			_starling.showStatsAt("left", "bottom");
			
			// Start Starling Framework.
			_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, 
				function(e:*):void 
				{
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					_starling.start();
				}
			);
			
			//程序被激活
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, 
				function (e:Event):void { _starling.start(); });
			//程序未激活
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, 
				function (e:Event):void { _starling.stop(); });
		}
		
		public function browser(location :String):Promise
		{
			this.url.parse(location);
			var controlClass :Class = this.controlPool.retrieve(this.url.address) as Class;
			navigator.changeScreen(new controlClass().view);
			return new Promise(this).complete();
		}
		
		public function registerControls():void
		{
			
		}
	}
}