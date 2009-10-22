﻿////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) Oleg Sivokon email: olegsivokon@gmail.com
//  
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//  Or visit http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
//
////////////////////////////////////////////////////////////////////////////////

package org.wvxvws.gui 
{
	//{imports
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.LayoutValidator;
	import org.wvxvws.gui.styles.ICSSClient;
	//}
	
	[Event(name="initialized", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="validated", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	* DIV class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class DIV extends Sprite implements IMXMLObject, ICSSClient, ILayoutClient
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property x
		//------------------------------------
		
		[Bindable("xChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>xChange</code> event.
		*/
		public override function get x():Number { return _transformMatrix.tx; }
		
		public override function set x(value:Number):void 
		{
			if (_transformMatrix.tx == value) return;
			_transformMatrix.tx = value;
			this.invalidate("_transformMatrix", _transformMatrix, true);
			super.dispatchEvent(new Event("xChange"));
		}
		
		//------------------------------------
		//  Public property y
		//------------------------------------
		
		[Bindable("yChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>yChange</code> event.
		*/
		public override function get y():Number { return _transformMatrix.ty; }
		
		public override function set y(value:Number):void 
		{
			if (_transformMatrix.ty == value) return;
			_transformMatrix.ty = value;
			this.invalidate("_transformMatrix", _transformMatrix, true);
			super.dispatchEvent(new Event("yChange"));
		}
		
		//------------------------------------
		//  Public property width
		//------------------------------------
		
		[Bindable("widthChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>widthChanged</code> event.
		*/
		public override function get width():Number { return _bounds.x; }
		
		public override function set width(value:Number):void 
		{
			if (_bounds.x == value) return;
			_bounds.x = value;
			this.invalidate("_bounds", _bounds, true);
			super.dispatchEvent(new Event("widthChanged"));
		}
		
		//------------------------------------
		//  Public property height
		//------------------------------------
		
		[Bindable("heightChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>heightChanged</code> event.
		*/
		public override function get height():Number { return _bounds.y; }
		
		public override function set height(value:Number):void 
		{
			if (_bounds.y == value) return;
			_bounds.y = value;
			this.invalidate("_bounds", _bounds, true);
			super.dispatchEvent(new Event("heightChanged"));
		}
		
		//------------------------------------
		//  Public property scaleX
		//------------------------------------
		
		[Bindable("scaleXChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>scaleXChanged</code> event.
		*/
		public override function get scaleX():Number { return _transformMatrix.a; }
		
		public override function set scaleX(value:Number):void 
		{
			if (_transformMatrix.a == value) return;
			_transformMatrix.a = value;
			this.invalidate("_transformMatrix", _transformMatrix, true);
			super.dispatchEvent(new Event("scaleXChanged"));
		}
		
		//------------------------------------
		//  Public property scaleY
		//------------------------------------
		
		[Bindable("scaleYChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>scaleYChanged</code> event.
		*/
		public override function get scaleY():Number { return _transformMatrix.d; }
		
		public override function set scaleY(value:Number):void 
		{
			if (_transformMatrix.d == value) return;
			_transformMatrix.d = value;
			this.invalidate("_transformMatrix", _transformMatrix, true);
			super.dispatchEvent(new Event("scaleYChanged"));
		}
		
		//------------------------------------
		//  Public property transform
		//------------------------------------
		
		[Bindable("transformChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>transformChanged</code> event.
		*/
		public override function get transform():Transform
		{
			return _userTransform ? _userTransform : super.transform;
		}
		
		public override function set transform(value:Transform):void 
		{
			invalidate("_userTransform", _userTransform, true);
			_userTransform = value;
			super.dispatchEvent(new Event("transformChanged"));
		}
		
		//------------------------------------
		//  Public property style
		//------------------------------------
		
		[Bindable("styleChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>styleChanged</code> event.
		*/
		public function get style():IEventDispatcher { return _style; }
		
		public function set style(value:IEventDispatcher):void 
		{
		   if (_style == value) return;
		   this.invalidate("_invalidProperties", _invalidProperties, true);
		   _style = value;
		   super.dispatchEvent(new Event("styleChanged"));
		}
		
		//------------------------------------
		//  Public property style
		//------------------------------------
		
		[Bindable("backgroundColorChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>backgroundColorChanged</code> event.
		*/
		public function get backgroundColor():uint { return _backgroundColor; }
		
		public function set backgroundColor(value:uint):void 
		{
			if (value == _backgroundColor) return;
			this.invalidate("_backgroundColor", _backgroundColor, false);
			_backgroundColor = value;
			super.dispatchEvent(new Event("backgroundColorChanged"));
		}
		
		//------------------------------------
		//  Public property style
		//------------------------------------
		
		[Bindable("backgroundAlphaChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>backgroundAlphaChanged</code> event.
		*/
		public function get backgroundAlpha():Number { return _backgroundAlpha; }
		
		public function set backgroundAlpha(value:Number):void 
		{
			if (value == _backgroundAlpha) return;
			this.invalidate("_backgroundAlpha", _backgroundAlpha, false);
			_backgroundAlpha = value;
			super.dispatchEvent(new Event("backgroundAlphaChanged"));
		}
		
		/* INTERFACE org.wvxvws.gui.styles.ICSSClient */
		
		public function get className():String { return _className; }
		
		public function set className(value:String):void
		{
			_className = value;
			this.initStyles();
		}
		
		/* INTERFACE org.wvxvws.gui.layout.ILayoutClient */
		
		public function get validator():LayoutValidator
		{
			if (!_validator)
			{
				if (parent is ILayoutClient) 
					_validator = (parent as ILayoutClient).validator;
				if (parent is Stage)
				{
					_validator = new LayoutValidator();
					_validator.append(this);
				}
			}
			return _validator;
		}
		
		public function get invalidProperties():Object { return _invalidProperties; }
		
		public function get layoutParent():ILayoutClient { return _layoutParent; }
		
		public function set layoutParent(value:ILayoutClient):void
		{
			if (_layoutParent === value) return;
			_layoutParent = value;
		}
		
		public function get childLayouts():Vector.<ILayoutClient> { return _childLayouts; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _invalidLayout:Boolean;
		protected var _transformMatrix:Matrix = new Matrix();
		protected var _bounds:Point = new Point(100, 100);
		protected var _nativeTransform:Transform;
		protected var _userTransform:Transform;
		protected var _background:Graphics;
		protected var _backgroundColor:uint = 0x999999;
		protected var _backgroundAlpha:Number = 0;
		protected var _style:IEventDispatcher;
		protected var _className:String;
		protected var _invalidProperties:Object = { };
		protected var _childLayouts:Vector.<ILayoutClient> = new <ILayoutClient>[];
		protected var _layoutParent:ILayoutClient;
		protected var _validator:LayoutValidator;
		protected var _hasPendingValidation:Boolean;
		protected var _hasPendingParentValidation:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DIV()
		{
			super();
			var nm:Array = getQualifiedClassName(this).split("::");
			_className = String(nm.pop());
			_nativeTransform = new Transform(this);
			this.invalidate("", undefined, true);
			if (stage) super.addEventListener(Event.ENTER_FRAME, deferredInitialize);
		}
		
		private function deferredInitialize(event:Event):void 
		{
			super.removeEventListener(Event.ENTER_FRAME, deferredInitialize);
			super.dispatchEvent(new GUIEvent(GUIEvent.INITIALIZED));
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
			this.initStyles();
			if (_document is DisplayObjectContainer)
			{
				(_document as DisplayObjectContainer).addChild(this);
			}
			if (_hasPendingValidation) this.validate(_invalidProperties);
			super.dispatchEvent(new GUIEvent(GUIEvent.INITIALIZED));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function validate(properties:Object):void
		{
			if (!_document) _validator = new LayoutValidator();
			else if (parent is ILayoutClient && !_validator)
			{
				_validator = (parent as ILayoutClient).validator;
				_layoutParent = parent as ILayoutClient;
				if ((parent as ILayoutClient).childLayouts.indexOf(this) < 0)
				{
					(parent as ILayoutClient).childLayouts.push(this);
				}
			}
			if (!_validator) _validator = new LayoutValidator();
			_validator.append(this, _layoutParent);
			if (!_background) _background = graphics;
			if (properties._backgroundColor !== undefined ||
				properties._backgroundAlpha !== undefined ||
				properties._bounds !== undefined) drawBackground();
			if (properties._userTransform) super.transform = _userTransform;
			else if (properties._transformMatrix)
			{
				_nativeTransform.matrix = _transformMatrix;
			}
			if (!_document) 
			{
				_document = this;
				this.initStyles();
				super.dispatchEvent(new GUIEvent(GUIEvent.INITIALIZED));
			}
			_invalidProperties = { };
			_invalidLayout = false;
			super.dispatchEvent(new GUIEvent(GUIEvent.VALIDATED));
		}
		
		protected function drawBackground():void
		{
			_background.clear();
			_background.beginFill(_backgroundColor, _backgroundAlpha);
			_background.drawRect(0, 0, _bounds.x, _bounds.y);
			_background.endFill();
		}
		
		public function invalidate(property:String, cleanValue:*, 
									validateParent:Boolean):void
		{
			_invalidProperties[property] = cleanValue;
			if (_validator) _validator.requestValidation(this, validateParent);
			else
			{
				_hasPendingValidation = true;
				_hasPendingParentValidation = 
							_hasPendingParentValidation || validateParent;
			}
			_invalidLayout = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function initStyles():void
		{
			var styleParser:Object;
			try
			{
				styleParser = getDefinitionByName("org.wvxvws.gui.styles.CSSParser");
			}
			catch (refError:Error) { return; };
			if (styleParser.parsed) styleParser.processClient(this);
			else styleParser.addPendingClient(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}