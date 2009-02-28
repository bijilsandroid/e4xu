﻿package org.wvxvws.xmlutils
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import mx.core.IMXMLObject;
	
	[Event(name="imchange", type="org.wvxvws.xmlutils.IMEvent")]
	
	/**
	* InteractiveModel class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class InteractiveModel extends Proxy implements IEventDispatcher, IMXMLObject
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
		
		protected var _map:XML;
		protected var _dispatcher:EventDispatcher;
		
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
		
		public function InteractiveModel() 
		{
			super();
			_dispatcher = new EventDispatcher(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function addEventListener(type:String, listener:Function, 
						useCapture:Boolean = false, priority:int = 0, 
						useWeakReference:Boolean = false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, 
												priority, useWeakReference);
		}
 	 	
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}
 	 	
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
 	 	
		public function removeEventListener(type:String, listener:Function, 
									useCapture:Boolean = false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
 	 	
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
		
		public function initialized(document:Object, id:String):void
		{
			trace(document, id);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		flash_proxy override function callProperty(name:*, ...rest):* 
		{
			switch (String(name))
			{
				case "addNamespace":
					return _map.addNamespace(rest[0]);
				case "appendChild":
					return _map.appendChild(rest[0]);
				case "attribute":
					return _map.attribute(rest[0]);
				case "attributes":
					return _map.attributes();
				case "child":
					return _map.child(rest[0]);
				case "childIndex":
					return _map.childIndex();
				case "children":
					return _map.children();
				case "comments":
					return _map.comments();
				case "contains":
					return _map.contains(rest[0]);
				case "copy":
					return _map.copy();
				case "descendants":
					return _map.descendants(rest[0]);
				case "elements":
					return _map.elements(rest[0]);
				case "hasComplexContent":
					return _map.hasComplexContent();
				case "hasSimpleContent":
					return _map.hasSimpleContent();
				case "inScopeNamespaces":
					return _map.inScopeNamespaces();
				case "insertChildAfter":
					return _map.insertChildAfter(rest[0], rest[1]);
				case "insertChildBefore":
					return _map.insertChildBefore(rest[0], rest[1]);
				case "length":
					return _map.length();
				case "localName":
					return _map.localName();
				case "name":
					return _map.name();
				case "namespace":
					return _map.namespace(rest[0]);
				case "namespaceDeclarations":
					return _map.namespaceDeclarations();
				case "nodeKind":
					return _map.nodeKind();
				case "normalize":
					return _map.normalize();
				case "parent":
					return _map.parent();
				case "prependChild":
					return _map.prependChild(rest[0]);
				case "processingInstructions":
					return _map.processingInstructions(rest[0]);
				case "removeNamespace":
					return _map.removeNamespace(rest[0]);
				case "replace":
					return _map.replace(rest[0], rest[1]);
				case "setChildren":
					return _map.setChildren(rest[0]);
				case "setLocalName":
					return _map.setLocalName(rest[0]);
				case "setName":
					return _map.setName(rest[0]);
				case "setNamespace":
					return _map.setNamespace(rest[0]);
				case "text":
					return _map.text();
				case "toString":
					return _map.toString();
				case "toXMLString":
					return _map.toXMLString();
				case "valueOf":
					return _map.valueOf();
				default:
					throw new IllegalOperationError("No method " + 
								name + " on LocalizationManager");
			}
			return undefined;
		}
		
		flash_proxy override function deleteProperty(name:*):Boolean 
		{
			_map.replace(name as Object, null);
			return true;
		}
		
		flash_proxy override function getProperty(name:*):* 
		{
			return _map[name];
		}
		
		flash_proxy override function hasProperty(name:*):Boolean 
		{
			if (_map[name].lenght()) return true;
			return false;
		}
		
		flash_proxy override function nextName(index:int):String 
		{
			return _map.*[index].name();
		}
		
		flash_proxy override function nextNameIndex(index:int):int 
		{
			if (index < _map.*.length()) return index + 1;
			return 0;
		}
		
		flash_proxy override function nextValue(index:int):* 
		{
			return _map.*[index];
		}
		
		flash_proxy override function setProperty(name:*, value:*):void 
		{
			if (_map[name].length() > 1) 
				throw new IllegalOperationError("Cannot assign value to multiple targets");
			_map[name] = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}