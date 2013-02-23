package us.sban.simplemvc.view.ui.flipbook{
	 /**
          by kingofkofs
     */
import flash.display.Sprite
import flash.display.StageAlign
import flash.geom.Point
public class Page extends Sprite{
	
	
	private var c_mc1:Sprite,c_mc2:Sprite
	private var target
	private var wid,hei,pa,pb
	private var targetPoint:Point=new Point()
	public var _rotation
	public var angle
	public function Page(_pa,_pb,_w,_h){
		pa=_pa
		pb=_pb
		wid=_w
		hei=_h
		c_mc1=new Sprite()
		c_mc2=new Sprite()
		addChild(c_mc1)
		addChild(c_mc2)
		c_mc1.addChild(_pa)
		c_mc2.addChild(_pb)
		target=c_mc2
		
	}
	public function get _target(){
		return target
	}
	public function updateRotation(_x,_y){
		angle=Math.atan2(targetPoint.y-_y,targetPoint.x-_x)
		_rotation=target.rotation=2*angle*180/Math.PI
	}
	public function setCor(_str:String):void{
		
		switch(_str){
			case StageAlign.TOP_LEFT:
			pb.x=-wid
			pb.y=0
			
			pa.x=-wid
			pa.y=0
			target=c_mc1
			targetPoint.x=-wid
			targetPoint.y=0
			c_mc2.rotation=0
			c_mc2.y=0
			c_mc2.x=0
			setChildIndex(c_mc1,numChildren-1)
			break
			
			case StageAlign.TOP_RIGHT:
			
			pa.x=0
			pa.y=0
			c_mc1.x=0
			c_mc1.y=0
			
			pb.x=0
			pb.y=0
			target=c_mc2
			targetPoint.x=wid
			targetPoint.y=0
			c_mc1.rotation=0
			
			setChildIndex(c_mc2,numChildren-1)
			break
			
			case StageAlign.BOTTOM_LEFT:
			pb.x=-wid
			pb.y=0
			
			pa.x=-wid
			pa.y=-hei
			target=c_mc1
			targetPoint.x=-wid
			targetPoint.y=hei
			c_mc2.rotation=0
			c_mc2.y=0
			c_mc2.x=0
			setChildIndex(c_mc1,numChildren-1)
			
			break
			
			case StageAlign.BOTTOM_RIGHT:
			
			pa.x=0
			pa.y=0
			c_mc1.x=0
			c_mc1.y=0
			
			pb.x=0
			pb.y=-hei
			target=c_mc2
			targetPoint.x=wid
			targetPoint.y=hei
			c_mc1.rotation=0
			c_mc1.y=0
			c_mc1.x=0
			setChildIndex(c_mc2,numChildren-1)
			break
		}
	}
	
	
}
}