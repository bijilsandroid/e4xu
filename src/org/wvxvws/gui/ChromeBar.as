﻿package org.wvxvws.gui 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.wvxvws.gui.skins.SkinProducer;
	
	/**
	 * ChromeBar class.
	 * @author wvxvw
	 */
	public class ChromeBar extends DIV
	{
		
		public function get label():String { return _label; }
		
		public function set label(value:String):void 
		{
			if (_label === value) return;
			_label = value;
			super.invalidate("_label", _label, false);
			super.dispatchEvent(new Event("labelChanged"));
		}
		
		public function get iconProducer():SkinProducer { return _iconProducer; }
		
		public function set iconProducer(value:SkinProducer):void 
		{
			if (_iconProducer === value) return;
			_iconProducer = value;
			super.invalidate("_iconProducer", _iconProducer, false);
			super.dispatchEvent(new Event("iconProducerChanged"));
		}
		
		public function get labelPadding():int { return _labelPadding; }
		
		public function set labelPadding(value:int):void 
		{
			if (_labelPadding === value) return;
			_labelPadding = value;
			super.invalidate("_labelPadding", _labelPadding, false);
			super.dispatchEvent(new Event("labelPaddingChanged"));
		}
		
		protected var _label:String;
		protected var _labelTXT:TextField;
		protected var _iconProducer:SkinProducer;
		protected var _icon:DisplayObject;
		protected var _labelFormat:TextFormat = new TextFormat("_sans", 11, 0, true);
		protected var _labelPadding:int = 4;
		
		public function ChromeBar() { super(); }
		
		public override function validate(properties:Object):void 
		{
			var iconClassChanged:Boolean = ("_iconProducer" in properties);
			var labelChanged:Boolean = ("_label" in properties) || 
										iconClassChanged || 
										("_labelPadding" in properties) ||
										("_iconFactory" in properties) || 
										("_bounds" in properties);
			super.validate(properties);
			if (iconClassChanged)
			{
				_icon = _iconProducer.produce(this);
				this.drawIcon();
			}
			if (labelChanged) this.drawLabel();
		}
		
		protected function drawLabel():void
		{
			if (_label !== null && _label !== "")
			{
				if (!_labelTXT)
				{
					_labelTXT = new TextField();
					_labelTXT.selectable = false;
					_labelTXT.defaultTextFormat = _labelFormat;
					_labelTXT.autoSize = TextFieldAutoSize.LEFT;
					_labelTXT.width = 1;
					_labelTXT.height = 1;
					_labelTXT.mouseEnabled = false;
					_labelTXT.tabEnabled = false;
				}
				_labelTXT.text = _label;
				if (_icon)
				{
					_labelTXT.scrollRect = new Rectangle(0, 0, 
						super.width - (_icon.width + _labelPadding + _icon.x), 
						_labelTXT.height);
					_labelTXT.x = _icon.x + _icon.width + 2;
				}
				else
				{
					_labelTXT.scrollRect = 
						new Rectangle(2, 0, super.width - _labelPadding, 
						_labelTXT.height);
					_labelTXT.x = 2;
				}
				_labelTXT.y = (super.height - _labelTXT.height) >> 1;
				if (!super.contains(_labelTXT)) super.addChild(_labelTXT);
			}
			else if (_labelTXT)
			{
				if (super.contains(_labelTXT)) super.removeChild(_labelTXT);
				_labelTXT = null;
			}
		}
		
		protected function drawIcon():void
		{
			if (_icon is InteractiveObject)
			{
				(_icon as InteractiveObject).addEventListener(
						MouseEvent.MOUSE_DOWN, icon_downHandler);
			}
			else
			{
				super.addEventListener(MouseEvent.MOUSE_DOWN, icon_downHandler);
			}
			if (_icon is DisplayObjectContainer)
			{
				(_icon as DisplayObjectContainer).mouseChildren = false;
				(_icon as DisplayObjectContainer).tabChildren = false;
			}
			_icon.x = 2;
			_icon.y = (super.height - _icon.height) >> 1;
			super.addChild(_icon);
		}
		
		protected function icon_downHandler(event:MouseEvent):void 
		{
			var t:InteractiveObject = event.currentTarget as InteractiveObject;
			if (t && t === _icon)
			{
				
			}
			else if (t === this)
			{
				
			}
		}
	}
	
}