package interfaces 
{
	import game.Room;
	import game.Avatar;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Nodebay.com
	 */
	
	public class RoomInterface extends Sprite
	{
		public var currentRoom:Room;
		public var playerAvatar:Avatar;
		
		public const walkSpeedX:uint = 3;
		public const walkSpeedY:uint = 1;
		public const runSpeedX:uint = 6;
		public const runSpeedY:uint = 3;
		
		public function RoomInterface(_playerAvatar:Avatar, _currentRoom:Room=null)
		{
			currentRoom = _currentRoom;
			playerAvatar = _playerAvatar;
		}
		
		public function keyDownHandler(e:KeyboardEvent):void
		{
			if (e.shiftKey)
			{
				playerAvatar.currentSpeedX = runSpeedX;
				playerAvatar.currentSpeedY = runSpeedY;
			}
			
			else
			{
				playerAvatar.currentSpeedX = walkSpeedX;
				playerAvatar.currentSpeedY = walkSpeedY;
			}
			
			switch (e.keyCode)
			{
				// North
				case 38:					
					playerAvatar.keysTriggered.north = true;				
					break;
				
				// South
				case 40:					
					playerAvatar.keysTriggered.south = true;					
					break;
				
				// East
				case 39:					
					playerAvatar.keysTriggered.east = true;					
					break;
				
				// West
				case 37:					
					playerAvatar.keysTriggered.west = true;					
					break;
			}
		}
		
		public function keyUpHandler(e:KeyboardEvent):void
		{
			if (e.shiftKey)
			{
				playerAvatar.currentSpeedX = runSpeedX;
				playerAvatar.currentSpeedY = runSpeedY;
			}
			
			else
			{
				playerAvatar.currentSpeedX = walkSpeedX;
				playerAvatar.currentSpeedY = walkSpeedY;
			}
			
			switch (e.keyCode)
			{				
				// North
				case 38:
					playerAvatar.keysTriggered.north = false;	
					break;
				
				// South
				case 40:					
					playerAvatar.keysTriggered.south = false;					
					break;
				
				// East
				case 39:					
					playerAvatar.keysTriggered.east = false;					
					break;
				
				// West
				case 37:					
					playerAvatar.keysTriggered.west = false;					
					break;
			}
		}
	}

}