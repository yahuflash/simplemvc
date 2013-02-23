package  us.sban.simplemvc.view.ui.flipbook{
     /**
          by kingofkofs
     */
	import flash.display.DisplayObject
	import flash.display.MovieClip
	import flash.display.Sprite
	
	import flash.geom.Point
	import flash.events.Event
	import flash.display.StageAlign
	public class Paper extends Sprite {
        
		
		private var pageMC
		public var lp:LimitPoint
		private var currentCor:String
		public var currentDir:String="right"
		public var targetPage
		private var mask_mc=new SemiCircleMasker;
		
		
		private var _width,_height
		public function Paper(pa,pb,pwid,phei) {
			
			visible=false
			addChild(mask_mc)
			_width=pwid
			_height=phei
			
		    mask_mc.width=Math.sqrt(_width*_width+_height*_height)
			
			mask_mc.height=mask_mc.width*2
         lp=new LimitPoint()
         lp.O=new Point(0,phei/2)
         lp.setSize(pwid,phei,new Point())
          pageMC=new Page(pa,pb,pwid,phei)
		 pageMC.mask=mask_mc
		  this.addChild(pageMC)
		 setCor(StageAlign.BOTTOM_RIGHT)
		start()
		 
		 
        setChildIndex(mask_mc,numChildren-1)
		
		
		
		
		}
		
		public function setCor(Cor:String){
			currentCor=Cor
			pageMC.setCor(Cor)
			
			targetPage=pageMC._target
			if(Cor==StageAlign.TOP_RIGHT||Cor==StageAlign.BOTTOM_RIGHT){
				currentDir="right"
			}else{
				currentDir="left"
				
			}
			//trace(currentDir)
			if(Cor==StageAlign.TOP_LEFT||Cor==StageAlign.TOP_RIGHT){
				mask_mc.y=0
				lp.changeTo("top")
			}else{
				
				lp.changeTo("bottom")
				mask_mc.y=_height
			}
			
			fix(Cor)
			
			
		}
		private function fix(Cor){
			if(Cor=="TL"){
				mask_mc.x=-_width
				mask_mc.y=0
		        mask_mc.rotation=180
				targetPage.rotation=90
				targetPage.x=-_width
			}else if(Cor=="TR"){
				mask_mc.x=0
				mask_mc.y=0
		        mask_mc.rotation=180
				targetPage.rotation=0
				targetPage.x=-_width
			}else if(Cor=="BL"){
				mask_mc.x=0
				
		        mask_mc.rotation=0
				targetPage.rotation=0
				targetPage.x=_width
			}else if(Cor=="BR"){
				mask_mc.x=0
				
		        mask_mc.rotation=180
				targetPage.rotation=0
				targetPage.x=-_width
			}
		}
		public function show(){
			mask_mc.visible=visible=true
			
		}
		public function hide(){
			mask_mc.visible=visible=false
			
		}
		private var started:Boolean=false
		public function start(){
			
			
			close()
			visible=true
			//addEventListener(Event.ENTER_FRAME,enterFrame)
			
			
		}
		public function Update(point:Point):void{
			lp.update(point.x,point.y)
			update()
		}
		
		
		private function enterFrame(e):void{
			lp.update(mouseX,mouseY)
			update()
		}
		public function close(){
			lp.close()
			update()
		}
		
		private function update():void{
			
			targetPage.x=lp.point.x
			targetPage.y=lp.point.y
			pageMC.updateRotation(lp.point.x,lp.point.y)
			
			
			
			//var r=(pageMC.angle*2)*180/Math.PI
			var _sin=Math.sin(pageMC.angle*2)
			var _x
			if(currentCor==StageAlign.BOTTOM_RIGHT){
			_x=_width-(_height-lp.point.y)/_sin
			if(!_sin){
			   mask_mc.x=_width-(_width-lp.point.x)/2
			}else{
			   mask_mc.x=_x
			}
			
			mask_mc.rotation=pageMC._rotation/2
			
			}else if(currentCor==StageAlign.TOP_RIGHT){
				//trace("ok")
				_x=_width-(-lp.point.y)/_sin
			if(!_sin){
			   mask_mc.x=_width-(_width-lp.point.x)/2
			}else{
			   mask_mc.x=_x
			}
			mask_mc.rotation=pageMC._rotation/2
			}else if(currentCor==StageAlign.TOP_LEFT){
				//trace("ok")
				_x=lp.point.y/_sin-_width
				//trace(_sin)
				//trace(_x)
				
			if(pageMC.angle==Math.PI){
			   mask_mc.x=(-_width-lp.point.x)/2+lp.point.x
			   mask_mc.rotation=pageMC._rotation/2
			}else{
				if(_sin){
			   mask_mc.x=_x
			   mask_mc.rotation=pageMC._rotation/2
				}else{
					 mask_mc.x=-_width
					  mask_mc.rotation=180
				}
			}
			
			}else if(currentCor==StageAlign.BOTTOM_LEFT){
				//trace("ok")
				_x=-_width-(_height-lp.point.y)/_sin
				//trace(_sin)
				//trace(_x)
				
			if(pageMC.angle==Math.PI){
			   mask_mc.x=(-_width-lp.point.x)/2+lp.point.x
			 mask_mc.rotation=pageMC._rotation/2
			}else{
				if(_sin){
				
			      mask_mc.x=_x
				  mask_mc.rotation=pageMC._rotation/2
				}else{
					 mask_mc.x=-_width
					  mask_mc.rotation=180
				}
			   
			}
			
			
			}
			
			
			//MovieClip(root)&&[MovieClip(root)._txt.text=String(Math.abs(_sin))]
			
		}
		
		public function get mask_rotation(){
			return  mask_mc.rotation
		}
		public function get mask_x(){
			return  mask_mc.x
		}
		public function get mask_y(){
			return  mask_mc.y
		}
		public function setPage(pa,pb):void{
		}
		
		public function get page(){
			return pageMC._target.getChildAt(0)
		}
		public var MemoryDir="right"
		public function get changedPageNum(){
			var lpx=lp.point.x
			
			
			//trace(lpx)
			if(Math.abs(lpx-(-_width))<3){
				
			   if(MemoryDir=="right"){
				 MemoryDir="left"
				return 1
				
			   }else{
				return 0
			   }
			}else if(Math.abs(lpx-_width)<3){
			   if(MemoryDir=="left"){
				   MemoryDir="right"
				   //trace("ok")
				return -1
				
			   }else{
				 
				return 0
			   }
			}
			
		}
	}
}
