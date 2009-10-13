﻿package org.wvxvws.gui 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import mx.core.IMXMLObject;
	
	/**
	 * Border class.
	 * @author wvxvw
	 */
	public class Border extends DIV
	{
		
		//------------------------------------
		//  Public property top
		//------------------------------------
		
		[Bindable("topChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>topChanged</code> event.
		*/
		public function get top():uint { return _thikness.top; }
		
		public function set top(value:uint):void 
		{
			if (_thikness.top === value) return;
			_thikness.top = value;
			super.invalidate("_thikness", _thikness, false);
			super.dispatchEvent(new Event("topChanged"));
		}
		
		//------------------------------------
		//  Public property left
		//------------------------------------
		
		[Bindable("leftChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>leftChanged</code> event.
		*/
		public function get left():uint { return _thikness.left; }
		
		public function set left(value:uint):void 
		{
			if (_thikness.left === value) return;
			_thikness.left = value;
			super.invalidate("_thikness", _thikness, false);
			super.dispatchEvent(new Event("leftChanged"));
		}
		
		//------------------------------------
		//  Public property bottom
		//------------------------------------
		
		[Bindable("bottomChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>bottomChanged</code> event.
		*/
		public function get bottom():uint { return _thikness.bottom; }
		
		public function set bottom(value:uint):void 
		{
			if (_thikness.bottom === value) return;
			_thikness.bottom = value;
			super.invalidate("_thikness", _thikness, false);
			super.dispatchEvent(new Event("bottomChanged"));
		}
		
		//------------------------------------
		//  Public property right
		//------------------------------------
		
		[Bindable("rightChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>rightChanged</code> event.
		*/
		public function get right():uint { return _thikness.right; }
		
		public function set right(value:uint):void 
		{
			if (_thikness.right === value) return;
			_thikness.right = value;
			super.invalidate("_thikness", _thikness, false);
			super.dispatchEvent(new Event("rightChanged"));
		}
		
		//------------------------------------
		//  Public property pattern
		//------------------------------------
		
		[Bindable("patternChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>patternChanged</code> event.
		*/
		public function get pattern():BitmapData { return _pattern; }
		
		public function set pattern(value:BitmapData):void 
		{
			if (_pattern === value) return;
			if (_pattern) _pattern.dispose();
			_pattern = value;
			super.invalidate("_pattern", _pattern, false);
			super.dispatchEvent(new Event("patternChanged"));
		}
		
		//------------------------------------
		//  Public property cornerPattern
		//------------------------------------
		
		[Bindable("cornerPatternChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>cornerPatternChanged</code> event.
		*/
		public function get cornerPattern():BitmapData { return _cornerPattern; }
		
		public function set cornerPattern(value:BitmapData):void 
		{
			if (_cornerPattern === value) return;
			if (_cornerPattern) _cornerPattern.dispose();
			_cornerPattern = value;
			super.invalidate("_cornerPattern", _cornerPattern, true);
			super.dispatchEvent(new Event("cornerPatternChanged"));
		}
		
		//------------------------------------
		//  Public property repeatChanged
		//------------------------------------
		
		[Bindable("repeatChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>repeatChanged</code> event.
		*/
		public function get repeat():Boolean { return _repeat; }
		
		public function set repeat(value:Boolean):void 
		{
			if (_repeat === value) return;
			_repeat = value;
			super.invalidate("_repeat", _repeat, true);
			super.dispatchEvent(new Event("repeatChanged"));
		}
		
		//------------------------------------
		//  Public property repeatChanged
		//------------------------------------
		
		[Bindable("smoothChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>smoothChanged</code> event.
		*/
		public function get smooth():Boolean { return _smooth; }
		
		public function set smooth(value:Boolean):void 
		{
			if (_smooth === value) return;
			_smooth = value;
			super.invalidate("_smooth", _smooth, true);
			super.dispatchEvent(new Event("smoothChanged"));
		}
		
		protected var _thikness:Rectangle = new Rectangle(1, 1, 0, 0);
		protected var _pattern:BitmapData;
		protected var _cornerPattern:BitmapData;
		protected var _repeat:Boolean;
		protected var _smooth:Boolean;
		protected var _drawBack:Boolean;
		
		public function Border() { super(); }
		
		public override function validate(properties:Object):void 
		{
			_drawBack = ("_pattern" in properties) || 
						("_cornerPattern" in properties) || 
						("_thikness" in properties) ||
						("_repeat" in properties) ||
						("_smooth" in properties);
			super.validate(properties);
			if (_drawBack) drawBackground();
		}
		
		protected override function drawBackground():void 
		{
			super.drawBackground();
			if (!_pattern) return;
			this.drawBorder();
		}
		
		protected function drawBorder():void
		{
			var m:Matrix = new Matrix();
			var patWidth:int = _pattern.width;
			var patHeight:int = _pattern.height;
			
			// top
			m.d = _thikness.top / patHeight;
			if (!_repeat) m.a = _bounds.x / patWidth;
			_background.beginBitmapFill(_pattern, m, _repeat, _smooth);
			_background.drawRect(0, 0, _bounds.x, _thikness.top);
			_background.endFill();
			
			// bottom
			m.d = _thikness.bottom / patHeight;
			if (!_repeat) m.a = _bounds.x / patWidth;
			m.rotate(Math.PI);
			m.ty = _bounds.y;
			m.tx = _bounds.x;
			_background.beginBitmapFill(_pattern, m, _repeat, _smooth);
			_background.drawRect(0, _bounds.y - _thikness.bottom, 
								_bounds.x, _thikness.bottom);
			_background.endFill();
			
			// left
			m = new Matrix();
			m.d = _thikness.left / patHeight;
			if (!_repeat) m.a = _bounds.y / patWidth;
			m.rotate(Math.PI * -0.5);
			m.ty = _bounds.y;
			_background.beginBitmapFill(_pattern, m, _repeat, _smooth);
			_background.drawRect(0, 0, _thikness.left, _bounds.y);
			_background.endFill();
			
			// right
			m = new Matrix();
			m.d = _thikness.right / patHeight;
			if (!_repeat) m.a = _bounds.y / patWidth;
			m.rotate(Math.PI * 0.5);
			m.tx = _bounds.x;
			_background.beginBitmapFill(_pattern, m, _repeat, _smooth);
			_background.drawRect(_bounds.x - _thikness.right, 0, 
								_thikness.right, _bounds.y);
			_background.endFill();
			
			if (_cornerPattern)
			{
				patWidth = _cornerPattern.width;
				patHeight = _cornerPattern.height;
				
				// TL corner
				m = new Matrix();
				m.a = _thikness.left / patWidth;
				m.d = _thikness.top / patHeight;
				_background.beginBitmapFill(_cornerPattern, m, _repeat, _smooth);
				_background.drawRect(0, 0, _thikness.left, _thikness.top);
				_background.endFill();
				
				// TR corner
				m = new Matrix();
				m.d = _thikness.right / patWidth;
				m.a = _thikness.top / patHeight;
				m.rotate(Math.PI * 0.5);
				m.tx = _bounds.x;
				_background.beginBitmapFill(_cornerPattern, m, _repeat, _smooth);
				_background.drawRect(_bounds.x - _thikness.right, 0, 
									_thikness.right, _thikness.top);
				_background.endFill();
				
				// BR corner
				m = new Matrix();
				m.a = _thikness.right / patWidth;
				m.d = _thikness.bottom / patHeight;
				m.rotate(Math.PI);
				m.tx = _bounds.x;
				m.ty = _bounds.y;
				_background.beginBitmapFill(_cornerPattern, m, _repeat, _smooth);
				_background.drawRect(_bounds.x - _thikness.right, 
									_bounds.y - _thikness.bottom, 
									_thikness.right, _thikness.bottom);
				_background.endFill();
				
				// BL corner
				m = new Matrix();
				m.d = _thikness.left / patWidth;
				m.a = _thikness.bottom / patHeight;
				m.rotate(Math.PI * 1.5);
				m.ty = _bounds.y;
				_background.beginBitmapFill(_cornerPattern, m, _repeat, _smooth);
				_background.drawRect(0, _bounds.y - _thikness.bottom, 
									_thikness.left, _thikness.bottom);
				_background.endFill();
			}
			
			_drawBack = false;
		}
	}
	
}