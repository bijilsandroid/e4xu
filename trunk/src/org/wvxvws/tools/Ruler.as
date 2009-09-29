﻿package org.wvxvws.tools 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.wvxvws.gui.DIV;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Ruler extends DIV
	{
		protected var _ratio:uint = 10;
		protected var _step:uint = 2;
		protected var _position:int;
		protected var _bitmapData:BitmapData;
		protected var _textFormat:TextFormat = new TextFormat("_sans", 10);
		protected var _textHolder:Sprite;
		protected var _direction:Boolean;
		protected var _numbersDown:Boolean;
		protected var _bigDivision:uint = 15;
		protected var _smallDivision:uint = 10;
		protected var _zoom:Number = 1;
		
		public function Ruler() { super(); }
		
		public function get ratio():uint { return _ratio; }
		
		public function set ratio(value:uint):void
		{
			var temp:Number = Math.max(1, value);
			if (temp === _ratio) return;
			invalidate("_ratio", _ratio, false);
			_ratio = temp;
			dispatchEvent(new Event("ratioChange"));
		}
		
		public function get step():uint { return _step; }
		
		public function set step(value:uint):void 
		{
			var temp:Number = Math.max(2, value);
			if (temp === _step) return;
			invalidate("_step", _step, false);
			_step = value;
			dispatchEvent(new Event("setpChange"));
		}
		
		public function get position():int { return _position; }
		
		public function set position(value:int):void 
		{
			if (_position === value) return;
			invalidate("_position", _position, false);
			_position = value;
			dispatchEvent(new Event("positionChange"));
		}
		
		public function get direction():Boolean { return _direction; }
		
		public function set direction(value:Boolean):void 
		{
			if (_direction === value) return;
			invalidate("_direction", _direction, false);
			_direction = value;
			dispatchEvent(new Event("directionChange"));
		}
		
		public function get zoom():Number { return _zoom; }
		
		public function set zoom(value:Number):void 
		{
			if (_zoom === value) return;
			invalidate("_zoom", _zoom, false);
			_zoom = value;
			dispatchEvent(new Event("zoomChange"));
		}
		
		public override function validate(properties:Object):void 
		{
			var ratioChanged:Boolean = 
							("_ratio" in properties) || ("_zoom" in properties) ||
							("_step" in properties) || ("_ratio" in properties) || 
							("_backgroundColor" in properties) || 
							("_backgroundAlpha" in properties) || 
							("_direction" in properties) || !_bitmapData;
			var needRedraw:Boolean = ratioChanged || ("_position" in properties) ||
							("_transformMatrix" in properties);
			super.validate(properties);
			var g:Graphics = super.graphics;
			var m:Matrix = new Matrix();
			var localStep:uint;
			var localWidth:uint;
			var divisionBig:Rectangle;
			var divisionSmall:Rectangle;
			var localBackgroundColor:uint;
			var field:TextField;
			var delta:int;
			var recicledFields:Vector.<TextField>;
			var fieldIndex:int;
			var textBounds:Rectangle;
			var numStart:int;
			var localIterator:uint;
			var prevField:TextField;
			if (ratioChanged)
			{
				if (_bitmapData) _bitmapData.dispose();
				localBackgroundColor = 
					(((super._backgroundAlpha * 0xFF) & 0xFF) << 24) | 
					super._backgroundColor;
				if (_direction)
				{
					_bitmapData = new BitmapData(super.width, 
										_step * _ratio * _zoom, true, localBackgroundColor);
					localWidth = _step * _ratio * _zoom;
					localStep = _step * _zoom;
					if (localStep < 2) localStep = 2;
					localIterator = localStep;
					divisionBig = new Rectangle(0, 0, _bigDivision, 1);
					divisionSmall = new Rectangle(0, 0, _smallDivision, 1);
					_bitmapData.fillRect(divisionBig, 0xFF000000);
					while (localStep < localWidth)
					{
						divisionSmall.y = localStep;
						_bitmapData.fillRect(divisionSmall, 0xFF000000);
						localStep += localIterator;
					}
				}
				else
				{
					_bitmapData = new BitmapData(_step * _ratio * _zoom, 
										super.height, true, localBackgroundColor);
					localWidth = _step * _ratio * _zoom;
					localStep = _step * _zoom;
					if (localStep < 2) localStep = 2;
					localIterator = localStep;
					divisionBig = new Rectangle(0, 0, 1, _bigDivision);
					divisionSmall = new Rectangle(0, 0, 1, _smallDivision);
					_bitmapData.fillRect(divisionBig, 0xFF000000);
					while (localStep < localWidth)
					{
						divisionSmall.x = localStep;
						_bitmapData.fillRect(divisionSmall, 0xFF000000);
						localStep += localIterator;
					}
				}
				
			}
			if (needRedraw)
			{
				delta = _position % (_step * _ratio);
				if (_direction) m.translate(0, delta * -1);
				else m.translate(delta * -1, 0);
				g.clear();
				g.beginBitmapFill(_bitmapData, m);
				g.drawRect(0, 0, super.width, super.height);
				g.endFill();
				if (!_textHolder) _textHolder = super.addChild(new Sprite()) as Sprite;
				recicledFields = new Vector.<TextField>(0, false);
				while (fieldIndex < _textHolder.numChildren)
				{
					recicledFields.push(_textHolder.getChildAt(fieldIndex) as TextField);
					fieldIndex++;
				}
				if (_direction)
				{
					while (recicledFields.length > super.height / (_step * _ratio * _zoom))
					{
						recicledFields.pop();
						_textHolder.removeChildAt(_textHolder.numChildren - 1);
					}
					while (recicledFields.length <= super.height / (_step * _ratio * _zoom))
					{
						recicledFields.push(createTextField(_textHolder));
					}
				}
				else
				{
					while (recicledFields.length > super.width / (_step * _ratio * _zoom))
					{
						recicledFields.pop();
						_textHolder.removeChildAt(_textHolder.numChildren - 1);
					}
					while (recicledFields.length <= super.width / (_step * _ratio * _zoom))
					{
						recicledFields.push(createTextField(_textHolder));
					}
				}
				fieldIndex = 0;
				textBounds = new Rectangle(0, 0, super.width, super.height);
				numStart = (_position - delta) / _step;
				while (fieldIndex < recicledFields.length)
				{
					if (_direction)
					{
						recicledFields[fieldIndex].y = 
									fieldIndex * _step * _ratio * _zoom - delta;
						recicledFields[fieldIndex].x = _bigDivision;
					}
					else
					{
						recicledFields[fieldIndex].x = 
									fieldIndex * _step * _ratio * _zoom - delta;
						recicledFields[fieldIndex].y = _bigDivision;
					}
					recicledFields[fieldIndex].text = 
							(numStart + fieldIndex * _ratio * _step).toString();
					if (prevField && prevField.hitTestObject(recicledFields[fieldIndex]))
					{
						if (_textHolder.contains(recicledFields[fieldIndex]))
						{
							_textHolder.removeChild(recicledFields[fieldIndex]);
						}
					}
					else
					{
						if (!_textHolder.contains(recicledFields[fieldIndex]))
						{
							_textHolder.addChild(recicledFields[fieldIndex]);
						}
					}
					if (_textHolder.contains(recicledFields[fieldIndex]))
					{
						prevField = recicledFields[fieldIndex];
					}
					fieldIndex++;
				}
				_textHolder.scrollRect = textBounds;
			}
		}
		
		protected function createTextField(where:Sprite):TextField
		{
			var field:TextField = new TextField();
			field.defaultTextFormat = _textFormat;
			field.width = 1;
			field.height = 1;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.selectable = false;
			return where.addChild(field) as TextField;
		}
	}
	
}