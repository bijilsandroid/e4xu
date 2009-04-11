﻿package org.wvxvws.base 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.Control;
	import org.wvxvws.gui.IPreloader;
	
	[SWF (width="800", height="600", scriptTimeLimit="15", frameRate="30", backgroundColor="0x3E2F1B")]
	
	/**
	* FrameOne class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class FrameOne extends MovieClip
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _ipreloader:IPreloader;
		protected var _frameTwoClass:Class;
		protected var _frameTwoAlias:String = "org.wvxvws.base::FrameTwo";
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		public function FrameOne()
		{
			super();
			stop();
		}
		
		public function get preloader():IPreloader { return _ipreloader; }
		
		public function set preloader(value:IPreloader):void 
		{
			_ipreloader = value;
			_ipreloader.target = loaderInfo;
			if (_frameTwoAlias) _ipreloader.classAlias = _frameTwoAlias;
			(_ipreloader as IEventDispatcher).addEventListener(Event.COMPLETE, completeHandler);
			addChild(_ipreloader as DisplayObject);
		}
		
		protected function completeHandler(event:Event):void 
		{
			if (framesLoaded < 2) return;
			gotoAndStop(2);
			(_ipreloader as IEventDispatcher).removeEventListener(
									Event.COMPLETE, completeHandler);
			_frameTwoClass = getDefinitionByName(_frameTwoAlias) as Class;
			removeChild(_ipreloader as DisplayObject);
			_ipreloader = null;
			var app:DisplayObject = new _frameTwoClass() as DisplayObject;
			(app as IMXMLObject).initialized(this, "frameTwo");
		}
		
		public function get frameTwoClass():Class { return _frameTwoClass; }
		
		public function get frameTwoAlias():String { return _frameTwoAlias; }
		
		public function set frameTwoAlias(value:String):void 
		{
			_frameTwoAlias = value;
			if (_ipreloader) _ipreloader.classAlias = _frameTwoAlias;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}