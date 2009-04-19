﻿package org.wvxvws.net 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.wvxvws.net.net_internal;
	
	/**
	* Synchronizer class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Synchronizer extends EventDispatcher
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
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static var _instance:Synchronizer;
		private static var _serviceID:int;
		private var _queves:Array = [];
		private var _available:Boolean = true;
		private var _timer:Timer = new Timer(1, 1);
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function Synchronizer(initializer:Initializer) 
		{
			super();
			if (!initializer) throw new Error("Cannot instantiate");
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
		}
		
		private function timerCompleteHandler(event:TimerEvent):void 
		{
			sendNext();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function getInstance():Synchronizer
		{
			if (_instance) return _instance;
			_instance = new Synchronizer(new Initializer());
			return _instance;
		}
		
		public function putOnQueve(target:IService, 
										method:String = "", priority:int = -1):int
		{
			var queve:Queve = new Queve(target, method, 
					priority > -1 ? priority : _queves.length, serviceID());
			_queves[queve.priority] = queve;
			if (_timer.currentCount) _timer.reset();
			_timer.start();
			return queve.id;
		}
		
		public function acknowledge(id:int):void
		{
			var i:int;
			var lnt:int = _queves.length;
			var queve:Queve
			for (i = 0; i < lnt; i++)
			{
				queve = _queves[i];
				if (queve && queve.id == id)
				{
					_queves.splice(i, 1);
					_available = true;
					sendNext();
					break;
				}
			}
		}
		
		private function sendNext():void
		{
			var queve:Queve;
			if (_available)
			{
				queve = hasNext();
				if (queve)
				{
					_available = false;
					queve.target.net_internal::internalSend(queve.id);
				}
				else
				{
					_available = true;
				}
			}
		}
		
		private function hasNext():Queve
		{
			for each (var queve:Queve in _queves)
			{
				if (queve) return queve;
			}
			return null;
		}
		
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
		
		private static function serviceID():int { return ++_serviceID; }
	}
	
}

internal final class Initializer 
{
	public function Initializer() { super(); }
}

import org.wvxvws.net.IService;

internal final class Queve
{
	public var target:IService;
	public var priority:int;
	public var method:String;
	public var id:int;
	
	public function Queve(target:IService, method:String, priority:int, id:int)
	{
		super();
		this.target = target;
		this.method = method;
		this.priority = priority;
		this.id = id;
	}
}