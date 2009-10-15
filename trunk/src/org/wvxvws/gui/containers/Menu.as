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

package org.wvxvws.gui.containers 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.IMenuRenderer;
	import org.wvxvws.gui.renderers.MenuRenderer;
	import org.wvxvws.utils.KeyUtils;
	//}
	
	[DefaultProperty("dataProvider")]
	
	/**
	* Menu class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Menu extends Pane
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const CHECK:String = "check";
		public static const CONTAINER:String = "container";
		public static const RADIO:String = "radio";
		public static const SEPARATOR:String = "separator";
		public static const NONE:String = "";
		
		//------------------------------------
		//  Public property hasMouse
		//------------------------------------
		
		public function get hasMouse():Boolean
		{
			var rect:Rectangle = 
				new Rectangle(super.x, super.y, _cumulativeWidth, _cumulativeHeight);
			var p:Point = new Point(super.mouseX, super.mouseY);
			return rect.containsPoint(p);
		}
		
		//------------------------------------
		//  Public property dataProvider
		//------------------------------------
		
		public override function set dataProvider(value:XML):void 
		{
			super.dataProvider = value;
			if (_isDeferredKeyInit) initiKeyListener();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _groups:Vector.<Vector.<IMenuRenderer>>;
		protected var _iconGenerator:Function;
		protected var _iconField:String = "@icon";
		protected var _hotkeysField:String = "@hotkeys";
		protected var _kindField:String = "@kind";
		protected var _enabledField:String = "@enabled";
		protected var _lastGroup:Vector.<IMenuRenderer>;
		protected var _cumulativeHeight:int;
		protected var _cumulativeWidth:int;
		protected var _nextY:int;
		protected var _borderWidth:Number;
		protected var _borderColor:uint;
		protected var _openedItem:IMenuRenderer;
		protected var _itemClickHandler:Function;
		protected var _childMenu:Menu;
		protected var _parentMenu:Menu;
		protected var _isRootMenu:Boolean;
		protected var _isDeferredKeyInit:Boolean;
		protected var _keyListenersMap:Dictionary = new Dictionary(true);
		
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
		
		public function Menu()
		{
			super();
			super._rendererFactory = MenuRenderer;
			super.addEventListener(GUIEvent.OPENED, openedHandler);
			super.addEventListener(GUIEvent.SELECTED, selectedHandler);
			super.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			super.addEventListener(Event.ADDED_TO_STAGE, atsHandler);
		}
		
		private function atsHandler(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, atsHandler);
			KeyUtils.obtainStage(stage);
		}
		
		private function rollOutHandler(event:MouseEvent):void 
		{
			if (_parentMenu && event.target is Menu) _parentMenu.collapseChildMenu();
		}
		
		private function selectedHandler(event:GUIEvent):void 
		{
			if (_itemClickHandler !== null)
			{
				_itemClickHandler((event.target as IMenuRenderer).data);
			}
		}
		
		private function openedHandler(event:GUIEvent):void 
		{
			event.stopImmediatePropagation();
			if (_openedItem === event.target) return;
			_openedItem = event.target as IMenuRenderer;
			if (_childMenu && super.contains(_childMenu))
			{
				if (!_childMenu.hasMouse) collapseChildMenu();
			}
			if (!_openedItem) return;
			if (_openedItem.kind !== CONTAINER || !_openedItem.enabled) return;
			_childMenu = new Menu();
			_childMenu.backgroundAlpha = _backgroundAlpha;
			_childMenu.backgroundColor = _backgroundColor;
			_childMenu.borderWidth = _borderWidth;
			_childMenu.borderColor = _borderColor;
			if (_useLabelField) _childMenu.labelField = _labelField;
			if (_useLabelFunction) _childMenu.labelFunction = _labelFunction;
			_childMenu.dataProvider = _openedItem.data;
			_childMenu.x = (_openedItem as DisplayObject).x + (_openedItem as DisplayObject).width;
			_childMenu.y = (_openedItem as DisplayObject).y;
			super.addChild(_childMenu);
			_childMenu.initialized(this, "_childMenu");
			_childMenu.validate(_childMenu.invalidProperties);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function collapseChildMenu():void
		{
			if (_childMenu && super.contains(_childMenu))
			{
				_openedItem = null;
				super.removeChild(_childMenu);
			}
		}
		
		public override function initialized(document:Object, id:String):void 
		{
			super.initialized(document, id);
			if (document is Menu) _parentMenu = document as Menu;
			else initiKeyListener();
		}
		
		protected function initiKeyListener():void
		{
			_isRootMenu = true;
			var hkList:XMLList;
			var compositeKey:Vector.<int>;
			if (_dataProvider)
			{
				hkList = _dataProvider..*.(hasOwnProperty(_hotkeysField));
				for each (var node:XML in hkList)
				{
					if (!node[_hotkeysField].toString().length) continue;
					compositeKey = Vector.<int>(node[_hotkeysField].toString().split("|"));
					_keyListenersMap[node] = KeyUtils.keysToKey(compositeKey);
					KeyUtils.registerHotKeys(compositeKey, defaultKeyHandler);
				}
			}
			else _isDeferredKeyInit = true;
		}
		
		private function defaultKeyHandler(event:KeyboardEvent):void
		{
			var sequenceCode:uint = KeyUtils.currentCombination;
			trace("defaultKeyHandler", sequenceCode.toString(16));
			if (_itemClickHandler !== null)
			{
				for (var obj:Object in _keyListenersMap)
				{
					if (_keyListenersMap[obj] === sequenceCode)
					{
						_itemClickHandler(obj);
					}
				}
			}
		}
		
		public override function validate(properties:Object):void 
		{
			super.validate(properties);
			drawIconBG();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function layOutChildren():void 
		{
			_cumulativeHeight = 0;
			_cumulativeWidth = 0;
			_nextY = 0;
			if (_childMenu && contains(_childMenu))
				super.removeChild(_childMenu);
			super.layOutChildren();
			super.width = _cumulativeWidth;
			super.height = _cumulativeHeight;
			var i:int = super.numChildren;
			var child:DisplayObject;
			while (i--)
			{
				child = super.getChildAt(i);
				child.width = _cumulativeWidth;
			}
			if (_childMenu) super.addChild(_childMenu);
		}
		
		protected override function createChild(xml:XML):DisplayObject 
		{
			var child:IMenuRenderer = super.createChild(xml) as IMenuRenderer;
			if (!child) return null;
			var childWidth:int;
			var bounds:Rectangle;
			child.iconFactory = (_iconGenerator != null ? _iconGenerator(xml) : 
				ApplicationDomain.currentDomain.hasDefinition(xml[_iconField].toString()) ? 
				ApplicationDomain.currentDomain.getDefinition(xml[_iconField].toString()) as Class : null);
			if (xml[_hotkeysField].toString().length)
			{
				child.hotKeys = Vector.<int>(xml[_hotkeysField].toString().split("|"));
			}
			if (xml.hasSimpleContent()) child.kind = xml[_kindField].toString();
			child.enabled = xml[_enabledField] != "false";
			if (child.kind !== SEPARATOR)
			{
				if (!_groups)
					_groups = new Vector.<Vector.<IMenuRenderer>>(0, false);
				if (!_lastGroup)
					_lastGroup = new Vector.<IMenuRenderer>(0, false);
				_lastGroup.push(child);
				_groups.push(_lastGroup);
			}
			else
			{
				_lastGroup = new Vector.<IMenuRenderer>(0, false);
				_lastGroup.push(child);
				_groups.push(_lastGroup);
			}
			(child as DisplayObject).y = _nextY;
			if (child.kind == SEPARATOR)
			{
				_nextY += 4;
				_cumulativeHeight += 4;
			}
			else
			{
				_nextY += (child as DisplayObject).height;
				_cumulativeHeight += (child as DisplayObject).height;
			}
			bounds = (child as DisplayObject).getBounds(this);
			childWidth = bounds.width + bounds.x;
			_cumulativeWidth = Math.max(_cumulativeWidth, childWidth);
			return child as DisplayObject;
		}
		
		protected function drawIconBG():void
		{
			var g:Graphics = super.graphics;
			g.clear();
			g.lineStyle(_borderWidth, _borderColor);
			g.beginFill(super._backgroundColor, super._backgroundAlpha);
			g.drawRect(0, 0, _cumulativeWidth + 2, _cumulativeHeight + 2);
			g.endFill();
			g.beginFill(0xD0D0D0);
			g.drawRect(0, 0, 20, _cumulativeHeight + 2);
			g.endFill();
		}
		
		public function get borderWidth():Number { return _borderWidth; }
		
		public function set borderWidth(value:Number):void 
		{
			_borderWidth = value;
		}
		
		public function get borderColor():uint { return _borderColor; }
		
		public function set borderColor(value:uint):void 
		{
			_borderColor = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}