package us.sban.simplemvc.view.ui
{
	// =================================================================================================
	//
	//  Starling Framework
	//  Copyright 2012 Gamua OG. All Rights Reserved.
	//
	//  This program is free software. You can redistribute and/or modify it
	//  in accordance with the terms of the accompanying license agreement.
	//
	// =================================================================================================
	
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	
	/** 
	 * 修改自starling框架的StatsDisplay
	 * 引自http://www.todoair.com/flascc与as3的性能对比（1）-2012-11-04/
	 * 
	 * A small, lightweight box that displays the current framerate, memory consumption and
	 *  the number of draw calls per frame. */
	public class StatsDisplay extends Sprite
	{
		
		private var mTextField:TextField;
		
		private var mFrameCount:int = 0;
		private var mDrawCount:int  = 0;
		private var mTotalTime:Number = 0;
		
		/** Creates a new Statistics Box. */
		public function StatsDisplay()
		{ 
			mTextField = new TextField();// 48, 25, "", BitmapFont.MINI, BitmapFont.NATIVE_SIZE, 0xffffff);
			mTextField.x = 2; 
			addChild(mTextField);
			mTextField.textColor = 0xFF0000;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			updateText(0, getMemory());
			
		}
		
		private function updateText(fps:Number, memory:Number):void
		{
			if (!stage) return;
			mTextField.text = "FPS: " + fps.toFixed(fps < 100 ? 1 : 0) + '/' + stage.frameRate + 
				"\nMEM: " + memory.toFixed(memory < 100 ? 1 : 0) ;
		}
		
		private function getMemory():Number
		{
			return System.totalMemory * 0.000000954; // 1 / (1024*1024) to convert to MB
		}
		private var lasTime:uint = 0;
		private function onEnterFrame(event:Event):void
		{
			mTotalTime = (getTimer() - lasTime) * 0.001;// += event.passedTime;
			mFrameCount++;
			
			if (mTotalTime > 1.0)
			{
				updateText(mFrameCount / mTotalTime, getMemory()); // DRW: ignore self
				mFrameCount = mTotalTime = 0;
				lasTime = getTimer();
			}else {
				
			}
		}
		
	}
}