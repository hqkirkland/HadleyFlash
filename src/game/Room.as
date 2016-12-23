package game 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import game.WalkMap;
	
	/**
	 * ...
	 * @author Nodebay.com
	 */
	public class Room extends Sprite
	{
		public var mainAvatar:Avatar;

		public function Room()
		{
			
		}
		
		public function addAvatar(_figure:Avatar):void
		{
			// Once we have a good design pattern going, we'll add the avatars as children to a WalkMap.
			// This will prevent border-crossing. Ideally.
			addChild(_figure);
			
			// We'll also make this more complex. Adding coordinates and whatnot.
		}
	}
	
	
}