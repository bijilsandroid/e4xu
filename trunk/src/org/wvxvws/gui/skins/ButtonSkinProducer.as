﻿package org.wvxvws.gui.skins 
{
	import flash.display.InteractiveObject;
	
	/**
	 * ButtonSkinProducer class.
	 * @author wvxvw
	 */
	public class ButtonSkinProducer extends AbstractProducer
	{
		protected var _states:Vector.<String>;
		protected var _stateClasses:Vector.<Class>;
		protected var _stateFactories:Vector.<Function>;
		
		public function ButtonSkinProducer(states:Vector.<String>,
											stateClasses:Vector.<Class>, 
											stateFactories:Vector.<Function> = null) 
		{
			super();
			_states = states;
			_stateClasses = stateClasses;
			_stateFactories = stateFactories;
		}
		
		public function produce(inContext:Object, state:String = null):InteractiveObject
		{
			var index:int;
			if (_states && _states.length)
			{
				if (state === null) state = _states[0];
				index = _states.indexOf(state);
			}
			else index = 0;
			if (index < 0) index = 0;
			if (_stateClasses && _stateClasses.length > index && _stateClasses[index])
				return new _stateClasses[index]();
			if (_stateFactories && _stateFactories.length > index && 
				_stateFactories[index])
				return _stateFactories[index](inContext, state);
			return null;
		}
	}

}