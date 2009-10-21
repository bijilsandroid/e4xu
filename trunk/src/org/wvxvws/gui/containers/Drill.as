﻿package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.containers.Pane;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.DrillRenderer;
	import org.wvxvws.gui.renderers.IDrillRenderer;
	import org.wvxvws.gui.renderers.IRenderer;
	
	[DefaultProperty("dataProvider")]
	
	/**
	 * Drill class.
	 * @author wvxvw
	 */
	public class Drill extends Pane
	{
		public function get renderClasses():Vector.<Class> { return _renderClasses; }
		
		public function set renderClasses(value:Vector.<Class>):void 
		{
			if (_renderClasses === value) return;
			_renderClasses = value;
			super.invalidate("_rendererClasses", _renderClasses, false);
		}
		
		public function get padding():Rectangle { return _padding; }
		
		public function set padding(value:Rectangle):void 
		{
			if (_padding === value) return;
			_padding = value;
			super.invalidate("_padding", _padding, false);
		}
		
		public function get selectedChild():IDrillRenderer { return _selectedChild; }
		
		protected var _renderClasses:Vector.<Class> = 
							new <Class>[DrillRenderer];
		protected var _closedNodes:Vector.<XML> = new <XML>[];
		protected var _closedChildren:Vector.<DisplayObject> = new <DisplayObject>[];
		protected var _nextY:int;
		protected var _padding:Rectangle = new Rectangle();
		protected var _gutter:int;
		protected var _selectedChild:IDrillRenderer;
		protected var _selectedItem:XML;
		
		public function Drill() 
		{
			super();
			super.addEventListener(GUIEvent.SELECTED, 
									selectedHandler, false, int.MAX_VALUE);
			super.addEventListener(GUIEvent.OPENED, 
									openedHandler, false, int.MAX_VALUE);
		}
		
		public function isNodeVisibe(node:XML):Boolean
		{
			while (node && node !== _dataProvider)
			{
				node = node.parent() as XML;
				if (_closedNodes.indexOf(node) > -1) return false;
			}
			return true;
		}
		
		protected override function layOutChildren():void 
		{
			if (_dataProvider === null) return;
			if (!_dataProvider.*.length()) return;
			if (!_renderClasses || !_renderClasses.length) return;
			_currentItem = 0;
			_removedChildren = _closedChildren.concat();
			var i:int;
			var allNodes:XMLList = _dataProvider..*;
			while (super.numChildren > i)
				_removedChildren.push(super.removeChildAt(0));
			_dispatchCreated = false;
			i = 0;
			var j:int = allNodes.length();
			var node:XML;
			var depth:int;
			_nextY = _padding.top;
			while (i < j)
			{
				node = allNodes[i];
				depth = Math.min(this.getNodeDepth(node), _renderClasses.length - 1);
				super._rendererFactory = _renderClasses[depth];
				this.createChild(node);
				i++;
			}
			var child:DisplayObject;
			_closedChildren.length = 0;
			for each (child in _removedChildren)
			{
				if (!super.contains(child) && _closedChildren.indexOf(child) < 0) 
				{
					_closedChildren.push(child);
				}
			}
			if (_dispatchCreated) 
				super.dispatchEvent(new GUIEvent(GUIEvent.CHILDREN_CREATED, false, true));
		}
		
		protected override function createChild(xml:XML):DisplayObject 
		{
			if (!isNodeVisibe(xml)) return null;
			var child:DisplayObject = super.createChild(xml);
			child.width = super._bounds.x;
			child.y = _nextY;
			_nextY += child.height + _gutter;
			return child;
		}
		
		protected function getNodeDepth(node:XML):int
		{
			var i:int;
			while (node.parent() is XML)
			{
				node = node.parent();
				i++;
			}
			return i;
		}
		
		private function selectedHandler(event:GUIEvent):void 
		{
			var lastSelected:IDrillRenderer;
			if (event.target is IDrillRenderer) lastSelected = _selectedChild;
			if (!(event.target is IDrillRenderer)) return;
			_selectedChild = event.target as IDrillRenderer;
			event.stopImmediatePropagation();
			_selectedItem = _selectedChild.data;
			if (lastSelected && lastSelected !== _selectedChild && 
				(lastSelected as Object).hasOwnProperty("selected"))
			{
				(lastSelected as Object).selected = false;
			}
			super.dispatchEvent(new GUIEvent(GUIEvent.SELECTED));
		}
		
		private function openedHandler(event:GUIEvent):void 
		{
			if (!(event.target is IDrillRenderer)) return;
			event.stopImmediatePropagation();
			var index:int;
			var renderer:DrillRenderer = event.target as DrillRenderer;
			if (renderer.closed) _closedNodes.push(renderer.data);
			else
			{
				index = _closedNodes.indexOf(renderer.data);
				if (index > -1) _closedNodes.splice(index, 1);
			}
			super._invalidProperties._dataProvider = _dataProvider;
			super.validate(super._invalidProperties);
			super.dispatchEvent(new GUIEvent(GUIEvent.OPENED));
		}
		
	}

}