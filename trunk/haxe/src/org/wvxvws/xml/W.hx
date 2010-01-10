﻿/**
 * Xml walker utility class.
 * @author wvxvw
 */
package org.wvxvws.xml;

class W 
{
	private var _root:Xml;
	private var _current:Array<Xml>;
	
	public function new(value:Xml)
	{
		this._root = value;
		this._current = new Array<Xml>();
		if (value != null && value.nodeType == Xml.Document)
		{
			this._current.push(value.firstElement());
		}
		else if (value != null)
		{
			this._current.push(value);
		}
	}
	
	public static function walk(value:Xml):W
	{
		return new W(value);
	}
	
	public function gen(x:Null<Xml>->Bool):W
	{
		var it:Iterator<Null<Xml>> = this._current.iterator();
		var itw:Iterator<Null<Xml>>;
		var working:Array<Xml> = null;
		var a:Array<Xml> = null;
		var node:Xml;
		
		while (it.hasNext())
		{
			node = it.next();
			if (node.nodeType == Xml.Element)
			{
				if (working == null) working = new Array<Xml>();
				itw = node.iterator();
				while (itw.hasNext())
				{
					working.push(itw.next());
				}
			}
		}
		if (working != null)
		{
			it = working.iterator();
			while (it.hasNext())
			{
				if (a == null) a = new Array<Xml>();
				node = it.next();
				if (x(node)) a.push(node);
			}
		}
		
		this._current = a;
		return this;
	}
	
	public function all(x:Null<Xml>->Bool):W
	{
		
		return this;
	}
	
	public function bac(x:Null<Xml>->Bool):W
	{
		
		return this;
	}
	
	public function att(x:Null<Xml>->Bool):W
	{
		
		return this;
	}
	
	public function ns(x:Null<Xml>->Bool):W
	{
		
		return this;
	}
	
	public function val(x:Null<Xml>->Bool):W
	{
		
		return this;
	}
	
	public function txt(x:Null<Xml>->Bool):W
	{
		
		return this;
	}
	
	public function ret():Array<Xml> { return this._current; }
}