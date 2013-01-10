package  sban.simplemvc.view {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * 2013/1/10更新：
	 * 在移动应用上显示文本，优先使用NativeText（包装StageText），而不应该使用该BitmapText
	 * NativeText支持边框，支持多字体多语言等等，特征优于BitmapText。
	 * @见sban.simplemvc.view.NativeText
	 * 
	 * 
	 * 在这种情况下使用：
	 * 在web应用上，为提高性能，将动态文本替换
	 * 
	 * 支持大小写字母、数字，特殊符号的位图文本组件
	 * 注意：
	 * 1，不支持中文
	 * 2，继承于sprite，不支持starling（在starling中使用位图字体，效果更佳）
	 * 3，不建议在AIR上使用
	 * 
	 *  
	 * @author james@codeandvisual.com
	 * 
	 * 
	 */	
	public class BitmapText extends Sprite{
		//
		//***************************************************************
		//
		//
		// PROPERTIES
		//
		//
		//***************************************************************
		private var _field:TextField
		private var _alphabet:Object
		private var _char_list:String = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#$%^&*()+=-?/.,<>;':[]{}`~\"\\"
		private var _copy_filters:Boolean = true
		private var _text:String = ""
		private var _margin:Number = -2
		private var _replace:Boolean = true
		private var _pool:Array = []
		private var _display:Array = []
		private var _align:String
		private var _edge_buffer:Number = 2
		//
		//***************************************************************
		//
		//
		// INIT
		//
		//
		//***************************************************************
		public function BitmapText(thisField:TextField,thisAlphabet:Object =null, thisCharList:String=null, thisProps:Object = null) {
			_field = thisField
			_alphabet = thisAlphabet
			_char_list = thisCharList || _char_list
			addProps(thisProps)
			init()
		}
		private  function addProps(thisProps:Object):void {
			if(thisProps!=null){
				for(var i:String in thisProps){
					if(this.hasOwnProperty(i)){
						this[i]=thisProps[i]
					}
				}
			}
		}
		private function init():void {
			initAlphabet()
			initDisplay()
			
		}
		//
		//***************************************************************
		//
		//
		// DISPLAY
		//
		//
		//***************************************************************
		private function initDisplay():void {
			var myFormat:TextFormat = _field.getTextFormat()
			_align = myFormat.align
			var myRight:Number =  right(_field)
			var myLeft:Number = left(_field)
			switch(_align) {
				case "right":
					x =myRight
					break
				case "center":
					x = myLeft+(myRight-myLeft)*.5
					break
				default:
					x = myLeft
					break
			}
			y = _field.y
			
			displayText(_field.text)
			if(_replace){
				x = Math.round(x)
				y = Math.round(y)
				var myParent:DisplayObjectContainer = _field.parent
				var myDepth:int = myParent.getChildIndex(_field)
				myParent.removeChild(_field)
				myParent.addChildAt(this, myDepth)
				
			}
		}
		public function displayText(thisText:String):void {
			var myCurrentLength:int = _text.length
			_text = thisText
			var myRequiredLength:int = _text.length
			var myDifference:int = myRequiredLength-myCurrentLength
			var myRemoveCount:int = myCurrentLength-myRequiredLength
			var myEdge:Number = 0
			for (var i:int = 0; i < _text.length; i++) {
				var myChar:String = _text.substr(i, 1)
				var myBitmap:Bitmap 
				if (i > _display.length - 1) {
					myBitmap = _pool.length > 0?_pool.shift():new Bitmap()
					_display.push(myBitmap)
				}else {
					myBitmap = _display[i]
				}
				myBitmap.bitmapData = _alphabet[myChar]
				myBitmap.x = myEdge
				addChild(myBitmap)
				myEdge +=myBitmap.width+_margin
			}
			for (var r:int = myCurrentLength; r > myRequiredLength; r--) {
				var myDisplay:Bitmap = _display.splice(r-1,1)[0]
				removeChild(myDisplay)
				_pool.push(myDisplay)
			}
			//
			//------------------------------------------------------
			// Align Text
			//------------------------------------------------------
			var myWidth:Number = width
			for (var a:int = 0; a < _display.length; a++) {
				var myBitmapAlign:Bitmap = _display[a]
				if (_align == "right") {
					myBitmapAlign.x -= myWidth
				} else if (_align == "center") {
					myBitmapAlign.x -= myWidth*.5
				}
			}
		}
		//
		//***************************************************************
		//
		//
		// POSITIONING
		//
		//
		//***************************************************************
		private function right(thisClip:DisplayObject):Number {
			var myBounds:Rectangle = thisClip.getBounds(thisClip.parent)
			return myBounds.x+myBounds.width
		}
		private function left(thisClip:DisplayObject):Number {
			var myBounds:Rectangle = thisClip.getBounds(thisClip.parent)
			return myBounds.x
		}
		//
		//***************************************************************
		//
		//
		// ALPHABET
		//
		//
		//***************************************************************
		private function initAlphabet():void { 
			if (_alphabet == null) {
				var myHolder:Sprite = new Sprite()
				_alphabet = {}
				var myField:TextField = new TextField()
				var myProps:Array = ["textColor", "sharpness","embedFonts","antiAliasType","backgroundColor","background","scaleX","scaleY"]
				for(var i:int=0;i<myProps.length;i++){
					myField[myProps[i]]=_field[myProps[i]]
				}
				
				myField.autoSize = "left"
				myField.wordWrap = false
				myField.width = myField.height = 2
				if (_copy_filters) {
					myField.filters = _field.filters
				}
				var myFormat:TextFormat = _field.getTextFormat()
				myFormat.align="left"
				myField.defaultTextFormat = myFormat
				//
				var myBounds:Rectangle
				myHolder.addChild(myField)
				for (var j:int = 0; j < _char_list.length; j++) {
					var myChar:String = _char_list.substr(j, 1)
					
					myField.text = myChar
					myHolder.cacheAsBitmap = true
					myBounds = myField.getBounds(myField.parent)
					try{
						var myData:BitmapData = new BitmapData(myBounds.width+_edge_buffer,myBounds.height+_edge_buffer,true,0)
						myData.draw(myHolder)
						_alphabet[myChar] = myData
					}catch (e:Error) {
						
					}
				}
			}
		}
		//
		//***************************************************************
		//
		//
		// GETTERS/SETTERS
		//
		//
		//***************************************************************
		public function get alphabet():Object {
			return _alphabet;
		}
		
		public function set alphabet(value:Object):void {
			_alphabet = value;
		}
		
		public function get copy_filters():Boolean {
			return _copy_filters;
		}
		
		public function set copy_filters(value:Boolean):void {
			_copy_filters = value;
		}
		
		public function get margin():Number {
			return _margin;
		}
		
		public function set margin(value:Number):void {
			_margin = value;
		}
		

		public function set text(value:String):void {
			displayText(value)
		}
		public function get text():String {
			return _text
		}
		
		public function get edge_buffer():Number 
		{
			return _edge_buffer;
		}
		
		public function set edge_buffer(value:Number):void 
		{
			_edge_buffer = value;
		}

		
	}
	
}
