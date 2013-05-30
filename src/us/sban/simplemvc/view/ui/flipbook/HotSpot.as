
package us.sban.simplemvc.view.ui.flipbook {
         /**
          by kingofkofs
         */
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	
	[Embed(source='FlipBook.swf',symbol='HotSpot')]
	public class HotSpot extends MovieClip {


		public function HotSpot(pw:Number,ph:Number,cor:String) {
			
			stop();
			width=height=pw*0.5
			
			gotoAndStop(cor);
			
			switch(cor){
				
				case "TL":
				
				x=-pw
				y=0
				
				break
				
				case "TR":
				x=pw
				y=0
				
				break
				
				case "BL":
				x=-pw
				y=ph
				break
				
				case "BR":
				x=pw
				y=ph
				
				
			}
		}
	}
}