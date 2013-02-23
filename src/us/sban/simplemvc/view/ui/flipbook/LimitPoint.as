package us.sban.simplemvc.view.ui.flipbook {
	 /**
          by kingofkofs
     */
    import flash.geom.Point;
	public class LimitPoint {


		private var width:Number;
		private var height:Number;
		
		private var topR:Number;
		private var bottomR:Number;
		
		public var isTop:Boolean;
		
		private var tPoint:Point=new Point
		private var bPoint:Point=new Point
		
		private var Op:Point=new Point
		public var _point:Point
		private var mPoint:Point=new Point
		private var dia:Number
		private var speed:Number=1
		private var tmpSpeed:Number=1
		public function LimitPoint() {
		}
		public function setSize(wid:Number,hei:Number,initPoint:Point):void {
			_point=new Point()
			width=wid;
			height=hei;
			
			topR=Math.sqrt(wid*wid+hei*hei);
			tPoint=new Point(Op.x,Op.y-hei/2)
			bPoint=new Point(Op.x,Op.y+hei/2)
			dia=Math.sqrt(width*width+height*height)
			update(initPoint.x,initPoint.y)
			
			speed=tmpSpeed
		}
		
		
		private function change(){
			var tmp=new Point(tPoint.x,tPoint.y)
			tPoint.x=bPoint.x
			tPoint.y=bPoint.y
			bPoint.x=tmp.x
			bPoint.y=tmp.y
			isTop=!isTop
			return isTop
			
		}
		public function changeTo(_str:String){
			if(_str=="top"){
				if(!isTop){
					change()
				}
			}else if(_str=="bottom"){
				if(isTop){
					change()
				}
			}
		}
		public function close(){
			
		   _point.x=width
		   _point.y=height
		}
		public function update(_x,_y):void {
            var angle
			
              mPoint.x=_x
			  mPoint.y=_y
			  
			  
			  if((!isTop&&_y<=Op.y+height/2)||(isTop&&_y>=Op.y-height/2)){
				  if(getDis(bPoint.x,bPoint.y,_x,_y)<=width){
			     _point.x=_x
			     _point.y=_y
				  }else{
				angle=getAngleByPoint(bPoint.x,bPoint.y,_x,_y)
				_point.x=Math.cos(angle)* width+bPoint.x
				_point.y=Math.sin(angle)* width+bPoint.y
					  
				  }
			  }else{
				  
				  if(getDis(tPoint.x,tPoint.y,_x,_y)<=dia){
			         _point.x=_x
			         _point.y=_y
				  }else{
					  angle=getAngleByPoint(tPoint.x,tPoint.y,_x,_y)
					  _point.x=Math.cos(angle)* dia+tPoint.x
					  _point.y=Math.sin(angle)* dia+tPoint.y
				   }
				  
			  }
			 
			 if(_point.x<Op.x-width){
				 _point.x=Op.x-width
				  isTop?_point.y=Op.y-height/2:_point.y=Op.y+height/2
				
			 }
			 if(_point.x>Op.x+width){
				 _point.x=Op.x+width
				 isTop?_point.y=Op.y-height/2:_point.y=Op.y+height/2
			 }
			 
			 
			
		}
		
		
		private function getDis(p1x,p1y,p2x,p2y):Number{ //求两点之间的距离
			var a=Math.abs(p1x-p2x)
			var b=Math.abs(p1y-p2y)
			
			return Math.sqrt(a*a+b*b)
			
		}
		private function getAngleByPoint(p1x,p1y,p2x,p2y){ //求两点所在直线的角度
			return Math.atan2(p2y-p1y,p2x-p1x)
		}
		
		public function set O(_p){
			Op=_p
			
		}
		
		public function get point(){
			return _point
		}
		
	}
}