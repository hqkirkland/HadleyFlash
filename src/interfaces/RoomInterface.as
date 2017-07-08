package interfaces 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import communication.FlashLoader;
	import communication.LoadEvent;
	import game.Avatar;
	
	/**
	 * ...
	 * @author Nodebay.com
	 */
	
	public class RoomInterface extends Sprite
	{
		public var playerAvatar:Avatar;
		public var playerAvatar2:Avatar;
		
		private var mapPoint:Point;
		private var nextPoint:Point;
		
		private var nextMapPixel:uint;
		
		public const walkSpeedX:uint = 3;
		public const walkSpeedY:uint = 1;
		public const runSpeedX:uint = 6;
		public const runSpeedY:uint = 3;
		
		public function RoomInterface(_playerAvatar:Avatar)
		{
			playerAvatar = _playerAvatar;
			
			var swfLoader:FlashLoader = new FlashLoader("DragonPort", "DragonPort");
			swfLoader.addEventListener(LoadEvent.FILE_DOWNLOADED, roomDownloaded);
		}
		
		private function roomDownloaded(e:LoadEvent):void
		{
			trace(e.assetLoader.contentLoaderInfo.applicationDomain.hasDefinition(""));
			
			var RoomInstance:Class = Class(e.assetLoader.contentLoaderInfo.applicationDomain.getDefinition("Main"));
			
			playerAvatar.currentRoom = new RoomInstance();
			
			playerAvatar.addEventListener(Event.ADDED, roomReady);
			addChild(playerAvatar.currentRoom);
		}
		
		private function roomReady(e:Event):void
		{
			playerAvatar.currentRoom.addChild(playerAvatar);
			
			playerAvatar.currentRoom.x = ((950 / 2) - (playerAvatar.currentRoom.width / 2));
			playerAvatar.currentRoom.y = ((550 / 2) - (playerAvatar.currentRoom.height / 2));
			
			var localPt:Point = playerAvatar.currentRoom.globalToLocal(new Point((950 / 2) - 20, (550 / 2) - 34 ));
			
			playerAvatar.x = localPt.x;
			playerAvatar.y = localPt.y;
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