# Skinning by Using Injection #

This article explains how skins are meant to work, as well as give you some guidance in creating skins of your own.


## Skin metadata ##

This library makes use of custom metadata tag `[Skin()]`. The allowed formats are as follows:

```
[Skin("fully.qualified.ClassName")]
[Skin(part="partName", type="fully.qualified.ClassName")]
```

This tag is allowed only on class definitions. This tag is repeatable. The class you specify in type parameter or as the only parameter must implement `ISkin` interface.

## ISkin interface ##
```
package org.wvxvws.gui.skins 
{
	public interface ISkin 
	{
		function get host():ISkinnable; 
		function set host(value:ISkinnable):void;
		
		function produce(inContext:Object, ...args):Object;
	}
}
```
When implementing skin you should write the `produce()` function in a way, it will return the type of the object, you are going to use in the hosting component.
The `host` property is populated when `SkinManager` creates the skin. In common case scenario you don't call `new MySkinClass()`, however, if you do so, keep in mind that some skins may require the `host` property to be non-null or even typed to the class of the component skinned by this skin.
In common case scenario `produce()` function will either return the reference to this skin, or create a clone of this skin, however, these are not the only options.

## ISkinnable interface ##
```
package org.wvxvws.gui.skins 
{
	public interface ISkinnable 
	{
		function get skin():Vector.<ISkin>;
		function set skin(value:Vector.<ISkin>):void;
		
		function get parts():Object;
		function set parts(value:Object):void;
	}
}
```
When implementing this interface, you will be required to obtain the skin from `SkinManager`. Most of the time your component will use either skin parts or an array of skins, however, it is possible to use both.
The typical implementation may look like this:
```
	[Skin("org.examples.SomeClassSkin")]
	[Skin(part="label", type="org.examples.PartSkin")]
	
	public class SomeClass extends Sprite implements ISkinnable
. . .
		public function SomeClass() 
		{
			super();
			this._skins = SkinManager.getSkin(this);
			this._skinsParts = SkinManager.getSkinParts(this);
			if (this._skins)
			{
				if (this._skins.length > 0)
					this._skin = this._skins[0];
			}
			if (this._skinsParts)
				this._labelSkin = this._skinsParts.label;
```
## Compilation Instructions ##
TBD