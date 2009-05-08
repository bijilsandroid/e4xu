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

package org.wvxvws.gui.skins 
{
	//{imports
	import flash.display.Graphics;
	//}
	
	/**
	* SkinFactory class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Drawings 
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
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Drawings() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		public static function drawRoundedCorners(g:Graphics, rx:int, ry:int,
							top:int, left:int, w:int, h:int, flags:uint):void
		{
			rx = rx > w >> 1 ? w >> 1 : rx;
			ry = ry > h >> 1 ? h >> 1 : ry;
			flags = flags > 15 ? 15 : flags;
			if (flags % 2) g.moveTo(left + rx, top); // LT
			else g.moveTo(left, top);
			if ((12 | flags) >> 1 == 7) // RT
			{
				g.lineTo(left + w - rx, top);
				g.curveTo(left + w, top, left + w, top + ry);
			}
			else g.lineTo(left + w, top);
			if ((8 | flags) >> 2 == 3) // RB
			{
				g.lineTo(left + w, top + h - ry);
				g.curveTo(left + w, top + h, left + w - rx, top + h);
			}
			else g.lineTo(left + w, top + h);
			if (flags > 7) // LB
			{
				g.lineTo(left + rx, top + h);
				g.curveTo(left, top + h, left, top + h - ry);
			}
			else g.lineTo(left, top + h);
			if (flags % 2) // LT
			{
				g.lineTo(left, top + ry);
				g.curveTo(left, top, left + rx, top);
			}
			else g.lineTo(left, top);
		}
		
		public static function drawPolygon(g:Graphics, rx:int, ry:int, top:int, 
				left:int, segments:uint, isStar:Boolean = false, delta:int = 0):void
		{
			
		}
		
		public static function drawPolyline(g:Graphics, points:Array /* of Point */):void
		{
			
		}
		
		public static function drawSector(g:Graphics, r:int, angleA:Number, 
												angleB:Number, top:int, left:int):void
		{
			
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
	}
	
}