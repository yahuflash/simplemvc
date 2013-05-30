package us.sban.simplemvc.view.ui.flipbook {
	/**
	 by kingofkofs ,2010.01.03
	 */
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import caurina.transitions.Tweener;
	
	/**
	 * <pre>
	 * var myFlipBook=new FlipBook(300,450); //new新建一个FlipBook翻书实例，大小是300*450，300是单页的宽度,总宽度则为600
	 
	 myFlipBook.addPaper(new FlipBookPage.p1(),new FlipBookPage.p2()) //为翻书效果添加第一张"纸"(正反面)内容
	 myFlipBook.addPaper(new FlipBookPage.p3(),new FlipBookPage.p4()) //为翻书效果添加第二张"纸"(正反面)内容
	 myFlipBook.addPaper(new FlipBookPage.p5(),new FlipBookPage.p6()) //为翻书效果添加第三张"纸"(正反面)内容
	 myFlipBook.addPaper(new FlipBookPage.p7(),new FlipBookPage.p8()) //为翻书效果添加第四张"纸"(正反面)内容
	 
	 
	 myFlipBook.x=stage.stageWidth/2 //翻书效果相对于舞台横向局中
	 myFlipBook.y=(stage.stageHeight-450)/2 //翻书效果相对于舞台竖向局中
	 
	 
	 addChild(myFlipBook); //翻书效果添加到舞台上，缺少这句则舞台上不显示翻书效果
	 * 
	 * </pre> 
	 * @author sban
	 * 
	 */	
	[Embed(source='FlipBook.swf',symbol='FlipBook')]
	public class FlipBook extends MovieClip {
		
		
		public var currentPage:uint=1 //定义当前页变量，默认为第1页
		public var totalPages:uint //定义总页数变量
		public var currentRightPaper //定义当前页面右部变量
		private var currentLeftPaper:Paper=null //定义当前页面左部变量，默认为空
		
		private var leftPagesArr:Array=[] //左部页面存储数组
		private var rightPagesArr:Array=[] //右部页面存储数组
		
		public var _width:Number //定义宽
		public var _height:Number //定义高
		
		private var fp:Point=new Point()
		private  var canFlip:Boolean=true;
		
		public var shadowF:MovieClip;
		public var shadowFR:MovieClip;
		public var shadowFMasker:MovieClip;
		public var shadowFRMasker:MovieClip;
		public var hots:MovieClip;
		public var papers:MovieClip;
		
		public function FlipBook(_w:Number,_h:Number){
			visible=false
			_width=_w //宽度等于参数_w
			_height=_h //高度等于参数_h
			fp.x=_w
			fp.y=_h
			addHS() //增加翻页点
			shadowFMasker._mc.width=_w
			shadowFMasker._mc.height=_h+1
			shadowFR.height=shadowF.height=Math.sqrt(_w*_w+_h*_h)*2
			shadowFRMasker.x=0
			shadowFRMasker.y=0
			shadowFRMasker.width=_w*2
			shadowFRMasker.height=_h
			addEventListener(Event.ENTER_FRAME,enterFrame)
			addEventListener(Event.ADDED_TO_STAGE,addTS)
			//cacheAsBitmap=true
		}
		
		
		public function addPaper(pageA:DisplayObject,pageB:DisplayObject,bm_smoothing:Boolean=true):void{
			totalPages++ 
			if(bm_smoothing){
				pageA is Bitmap&&(Bitmap(pageA).smoothing=true)
				pageB is Bitmap&&(Bitmap(pageB).smoothing=true)
			}
			
			var paper:Paper=new Paper(pageA,pageB,_width,_height)
			
			
			papers.addChild(paper)
			papers.setChildIndex(paper,0)
			rightPagesArr.push(paper)
			
			currentPaper=rightPagesArr[0]
			
		}
		private var currentPaper:Paper=null
		var init=false
		public function enterFrame(e):void{
			if(currentPaper){
				updatefp()
				currentPaper.Update(fp)
				shadowF.rotation=currentPaper.mask_rotation
				
				shadowFR.x=shadowF.x=currentPaper.mask_x
				shadowFR.y=shadowF.y=currentPaper.mask_y
				shadowFMasker.x=currentPaper.lp.point.x
				shadowFMasker.y=currentPaper.lp.point.y
				shadowFMasker.rotation=currentPaper.mask_rotation*2
				shadowFR.rotation=shadowFMasker.rotation/2
				shadowFR.scaleX=currentPaper.currentDir=="right"?1:-1
				
				shadowFR.alpha=(Math.abs(shadowFR.x)/_width)+0.3
				shadowFMasker._mc.x=currentPaper.page.x
				shadowFMasker._mc.y=currentPaper.page.y
				if(!init){
					currentPaper=null
					visible=true
					init=true
				}
				
			}
			
			
			
		}
		private var isDown:Boolean,isOver:Boolean
		private function updatefp(){
			if((isDown||isOver)&&!isAuto){
				fp.x+=(mouseX-fp.x)*0.6
				fp.y+=(mouseY-fp.y)*0.6
			}
			
		}
		
		private var hs1,hs2,hs3,hs4 //定义四个翻页点
		
		private function addHS(){
			hs1=new HotSpot(_width,_height,"TL") //左上角翻页点TL=TOP-LEFT
			hs2=new HotSpot(_width,_height,"TR") //右上角翻页点TR=TOP-RIGHT
			hs3=new HotSpot(_width,_height,"BL") //左下角翻页点BL=BOTTOM-LEFT
			hs4=new HotSpot(_width,_height,"BR") //右下角翻页点BR=BOTTOM-RIGHT
			hots.addChild(hs1) //翻页点添加到舞台
			hots.addChild(hs2)
			hots.addChild(hs3)
			hots.addChild(hs4)
			for(var j=1;j<=4;j++){ //为每个翻页点添加翻页事件的鼠标侦听
				this["hs"+j].addEventListener(MouseEvent.MOUSE_DOWN,meHandler)
				this["hs"+j].addEventListener(MouseEvent.MOUSE_OVER,meHandler)
				this["hs"+j].addEventListener(MouseEvent.MOUSE_OUT,meHandler)
				this["hs"+j].addEventListener(MouseEvent.MOUSE_MOVE,meHandler)
				
			}
			currentHS=hs4 //设置默认翻页点为hs4
			hots.alpha=.5 //设置翻页点透明不可见
		}
		private function addTS(e){
			this.stage.addEventListener(MouseEvent.MOUSE_UP,meHandler)
		}
		
		
		
		
		private function fpgotoCor(cor:String){
			Tweener.removeTweens(fp)
			if(cor==StageAlign.TOP_LEFT){
				fp.x=hs1.x,fp.y=hs1.y
			}else  if(cor==StageAlign.TOP_RIGHT){
				fp.x=hs2.x,fp.y=hs2.y
			}else  if(cor==StageAlign.BOTTOM_LEFT){
				fp.x=hs3.x,fp.y=hs3.y
			}else  if(cor==StageAlign.BOTTOM_RIGHT){
				fp.x=hs4.x,fp.y=hs4.y
			}
		}
		private function gotoCor(cor:String){
			
			if(isReady&&isOver){
				if(cor==StageAlign.TOP_LEFT){
					gotoHSPoint(hs1)
				}else  if(cor==StageAlign.TOP_RIGHT){
					gotoHSPoint(hs2)
				}else  if(cor==StageAlign.BOTTOM_LEFT){
					gotoHSPoint(hs3)
					
				}else  if(cor==StageAlign.BOTTOM_RIGHT){
					gotoHSPoint(hs4)
					
				}
				isReady=false
			}
		}
		
		private function gotoHSPoint(_hs):void{
			var hs=_hs
			if(isReady){
				
				
				if(fp.x<=0){
					
					if(hs==hs2){
						hs=hs1
						leftPagesArr.push(rightPagesArr[0])
						rightPagesArr.shift()
					}else if(hs==hs4){
						hs=hs3
						leftPagesArr.push(rightPagesArr[0])
						rightPagesArr.shift()
					}
					
				}else {
					if(hs==hs1){
						
						rightPagesArr.unshift(leftPagesArr[leftPagesArr.length-1])
						leftPagesArr.splice(leftPagesArr.length-1,1)
						hs=hs2
					}else if(hs==hs3){
						rightPagesArr.unshift(leftPagesArr[leftPagesArr.length-1])
						leftPagesArr.splice(leftPagesArr.length-1,1)
						hs=hs4
					}
					
				}
				
				isReady=false
				
				Tweener.removeTweens(fp)
				if((fp.y<0&&currentPaper.lp.isTop)||(fp.y>_height&&!currentPaper.lp.isTop)){
					Tweener.addTween(fp, {x:hs.x, time:.5, transition:"easeOutSine"});
					Tweener.addTween(fp, {y:hs.y, time:.5, transition:"easeOutBack",onComplete:complete});
				}else{
					Tweener.addTween(fp, {x:hs.x,y:hs.y, time:.5, transition:"easeOutSine",onComplete:complete});
				}
				function complete(){
					
					fadeOutShadow()
					isReady=true
					
					
					if(leftPagesArr.length){
						papers.setChildIndex(leftPagesArr[leftPagesArr.length-1],papers.numChildren-1)
					}
					if(rightPagesArr.length){
						papers.setChildIndex(rightPagesArr[0],papers.numChildren-1)
					}
					hs==hs1&&currentPaper.setCor("TL")
					hs==hs2&&currentPaper.setCor("TR")
					hs==hs3&&currentPaper.setCor("BL")
					hs==hs4&&currentPaper.setCor("BR")
					currentPaper=null
					//removeEventListener(Event.ENTER_FRAME,enterFrame)
					
					/*
					
					over(checkIsOn())
					
					*/ 
				}
			}
			
		}
		
		private function fadeInShadow(){
			Tweener.removeTweens(shadowF)
			Tweener.removeTweens(shadowFR)
			shadowFR.visible=shadowF.visible=true
			Tweener.addTween(shadowF, {alpha:1,visible:true, time:0, transition:"easeOutSine"});
			Tweener.addTween(shadowFR, {alpha:1,visible:true, time:0, transition:"easeOutSine"});
			
		}
		private function fadeOutShadow(){
			Tweener.removeTweens(shadowF)
			Tweener.removeTweens(shadowFR)
			Tweener.addTween(shadowF, {alpha:0,visible:false, time:.5, transition:"easeOutSine"});
			Tweener.addTween(shadowFR, {alpha:0,visible:false, time:.5, transition:"easeOutSine"});
		}
		private function checkIsOn(){
			for(var j=1;j<=4;j++){
				if(this["hs"+j].hitTestPoint(this.mouseX+x,this.mouseY+y,true)){
					
					
					
					if(this["hs"+j]==hs1){
						currentPaper.setCor(StageAlign.TOP_LEFT)
					}
					if(this["hs"+j]==hs2){
						currentPaper.setCor(StageAlign.TOP_RIGHT)
					}
					if(this["hs"+j]==hs3){
						currentPaper.setCor(StageAlign.BOTTOM_LEFT)
					}
					if(this["hs"+j]==hs4){
						currentPaper.setCor(StageAlign.BOTTOM_RIGHT)
					}
					fp.x=this["hs"+j].x
					fp.y=this["hs"+j].y
					
					return this["hs"+j]
					
				}
			}
			return false
		}
		
		
		private var isReady:Boolean=true
		private var currentHS,currentOHS
		private function meHandler(e):void{
			
			if(isReady){
				if(isDown){
					if(e.type==MouseEvent.MOUSE_UP&&!isAuto){
						isDown=false
						
						gotoHSPoint(currentHS)
					}
					
				}
				var et=e.target
				
				if(e.type==MouseEvent.MOUSE_DOWN){
					
					fadeInShadow()
					
					if(et==hs1){
						if(leftPagesArr.length){
							
							isDown=true
							currentPaper=leftPagesArr[leftPagesArr.length-1]
							currentPaper.setCor(StageAlign.TOP_LEFT)
							!isOver&&fpgotoCor(StageAlign.TOP_LEFT)
							
							currentHS=et
							papers.setChildIndex(currentPaper,papers.numChildren-1)
							isOver=false
						}
						
					}
						
					else if(et==hs2){
						if(rightPagesArr.length){
							
							
							isDown=true
							currentPaper=rightPagesArr[0]
							currentPaper.setCor(StageAlign.TOP_RIGHT)
							!isOver&&fpgotoCor(StageAlign.TOP_RIGHT)
							
							currentHS=et
							papers.setChildIndex(currentPaper,papers.numChildren-1)
							isOver=false
						}
						
					}
						
					else if(et==hs3){
						if(leftPagesArr.length){
							
							isDown=true
							currentPaper=leftPagesArr[leftPagesArr.length-1]
							currentPaper.setCor(StageAlign.BOTTOM_LEFT)
							!isOver&&fpgotoCor(StageAlign.BOTTOM_LEFT)
							
							currentHS=et
							papers.setChildIndex(currentPaper,papers.numChildren-1)
							isOver=false
						}
						
					}
						
					else if(et==hs4){
						
						if(rightPagesArr.length){
							
							isDown=true
							currentPaper=rightPagesArr[0]
							currentPaper.setCor(StageAlign.BOTTOM_RIGHT)
							!isOver&&fpgotoCor(StageAlign.BOTTOM_RIGHT)
							
							currentHS=et
							papers.setChildIndex(currentPaper,papers.numChildren-1)
							isOver=false
						}
					}
					
					
				}
				/////////////////////
				
				if((e.type==MouseEvent.MOUSE_OVER||e.type==MouseEvent.MOUSE_MOVE)&&!isDown&&!isOver){
					over(et)
				}
				
				//////////////////////
				/////////////////////
				
				if(e.type==MouseEvent.MOUSE_OUT&&!isDown){
					if(et==hs1){
						if(leftPagesArr.length){
							
							gotoCor(StageAlign.TOP_LEFT)
							isOver=false
						}
						
					}
						
					else if(et==hs2){
						if(rightPagesArr.length){
							
							gotoCor(StageAlign.TOP_RIGHT)
							isOver=false
						}
						
					}
						
					else if(et==hs3){
						if(leftPagesArr.length){
							
							gotoCor(StageAlign.BOTTOM_LEFT)
							isOver=false
						}
						
					}
						
					else if(et==hs4){
						
						if(rightPagesArr.length){
							
							
							gotoCor(StageAlign.BOTTOM_RIGHT)
							isOver=false
						}
					}
				}
				////////////////////////////
				
				
				
				
				
				
				////////////////////////////
				
			}}
		private var isAuto
		public function next(){
			if(currentPaper==null&&rightPagesArr.length){
				
				currentPaper=rightPagesArr[0]
				papers.setChildIndex(currentPaper,papers.numChildren-1)
				currentPaper.setCor("BR")
				isDown=true
				isAuto=true
				fp.x=_width
				fp.y=_height
				widxwid=_width*_width
				fadeInShadow()
				scaleR=Math.floor((Math.random()*0.5)*1000)/1000
				Tweener.addTween(fp, {x:hs3.x, time:1, transition:"easeOutSine",onComplete:autoCompleteL,onUpdate:autoUpdate});
				
				
			}
			
			
		}
		private var widxwid,scaleR
		private function autoCompleteL(){
			isDown=isAuto=false
			
			fadeOutShadow()
			isReady=true
			
			
			
			///////////////
			
			leftPagesArr.push(rightPagesArr[0])
			rightPagesArr.shift()
			if(leftPagesArr.length){
				papers.setChildIndex(leftPagesArr[leftPagesArr.length-1],papers.numChildren-1)
			}
			if(rightPagesArr.length){
				papers.setChildIndex(rightPagesArr[0],papers.numChildren-1)
			}
			currentPaper.setCor("BL")
			currentPaper=null
		}
		private function autoCompleteR(){
			isDown=isAuto=false
			
			fadeOutShadow()
			isReady=true
			
			
			
			///////////////
			
			
			rightPagesArr.unshift(currentPaper)
			leftPagesArr.splice(leftPagesArr.length-1,1)
			if(leftPagesArr.length){
				papers.setChildIndex(leftPagesArr[leftPagesArr.length-1],papers.numChildren-1)
			}
			if(rightPagesArr.length){
				papers.setChildIndex(rightPagesArr[0],papers.numChildren-1)
			}
			currentPaper.setCor("BR")
			currentPaper=null
		}
		private function autoUpdate(){
			fp.y=_height-Math.sqrt(widxwid-fp.x*fp.x)*scaleR
		}
		public function prev(){
			if(currentPaper==null&&leftPagesArr.length){
				
				currentPaper=leftPagesArr[leftPagesArr.length-1]
				papers.setChildIndex(currentPaper,papers.numChildren-1)
				currentPaper.setCor("BL")
				isDown=true
				isAuto=true
				fp.x=-_width
				fp.y=_height
				widxwid=_width*_width
				fadeInShadow()
				scaleR=Math.floor((Math.random()*0.5)*1000)/1000
				Tweener.addTween(fp, {x:hs4.x, time:1, transition:"easeOutSine",onComplete:autoCompleteR,onUpdate:autoUpdate});
				
				
			}
			
		}
		public function gotoPage(num:Number){
			//暂未实现
		}
		public function gotoMain(){
			//暂未实现
		}
		public function gotoEnd(){
			//暂未实现
		}
		private function over(et){
			if(et){
				fadeInShadow()
				if(et==hs1){
					if(leftPagesArr.length){
						
						currentPaper=leftPagesArr[leftPagesArr.length-1]
						currentPaper.setCor(StageAlign.TOP_LEFT)
						fpgotoCor(StageAlign.TOP_LEFT)
						isOver=true
					}
					
				}
					
				else if(et==hs2){
					if(rightPagesArr.length){
						
						currentPaper=rightPagesArr[0]
						currentPaper.setCor(StageAlign.TOP_RIGHT)
						fpgotoCor(StageAlign.TOP_RIGHT)
						isOver=true
					}
					
				}
					
				else if(et==hs3){
					if(leftPagesArr.length){
						
						currentPaper=leftPagesArr[leftPagesArr.length-1]
						currentPaper.setCor(StageAlign.BOTTOM_LEFT)
						fpgotoCor(StageAlign.BOTTOM_LEFT)
						isOver=true
					}
					
				}
					
				else if(et==hs4){
					
					if(rightPagesArr.length){
						
						currentPaper=rightPagesArr[0]
						currentPaper.setCor(StageAlign.BOTTOM_RIGHT)
						fpgotoCor(StageAlign.BOTTOM_RIGHT)
						isOver=true
					}
				}
				
			}
		}
	}
}