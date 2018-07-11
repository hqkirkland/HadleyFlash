package interfaces 
{
	import flash.display.DisplayObject;
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
		public var roomReady:Boolean = false;
		
		private var mapPoint:Point;
		private var nextPoint:Point;
		
		private var nextMapPixel:uint;
		
		public const walkSpeedX:uint = 3;
		public const walkSpeedY:uint = 1;
		public const runSpeedX:uint = 5;
		public const runSpeedY:uint = 2;
		
		public function RoomInterface(_playerAvatar:Avatar)
		{
			playerAvatar = _playerAvatar;
			
			var swfLoader:FlashLoader = new FlashLoader("DragonPort", "DragonPort");
			swfLoader.addEventListener(LoadEvent.FILE_DOWNLOADED, roomDownloaded);
		}
		
		private function roomDownloaded(e:LoadEvent):void
		{
			// trace(e.assetLoader.contentLoaderInfo.applicationDomain.hasDefinition(""));
			
			var RoomInstance:Class = Class(e.assetLoader.contentLoaderInfo.applicationDomain.getDefinition("Main"));
			
			playerAvatar.currentRoom = new RoomInstance();
			
			playerAvatar.currentRoom.addEventListener(Event.ADDED, prepareRoom);
			addChild(playerAvatar.currentRoom);
			
		}
		
		private function prepareRoom(e:Event):void
		{
			playerAvatar.currentRoom.addChild(playerAvatar);
			
			playerAvatar.currentRoom.x = ((950 / 2) - (playerAvatar.currentRoom.width / 2));
			playerAvatar.currentRoom.y = ((550 / 2) - (playerAvatar.currentRoom.height / 2));
			
			var localPt:Point = playerAvatar.currentRoom.globalToLocal(new Point((950 / 2) - 20, (550 / 2) - 34 ));
			
			playerAvatar.x = localPt.x;
			playerAvatar.y = localPt.y;
			
			roomReady = true;
		}
		
		public function checkLayer():void
		{
			var layerCount:int = playerAvatar.currentRoom.numChildren;
			var objArray:Array = []
			
			// BubbleSort algorithm.
			for (var i:int = 0; i < layerCount - 1; i++)
			{
				for (var n:int = i + 1; n < layerCount; n++)
				{
					var objectI:DisplayObject = playerAvatar.currentRoom.getChildAt(i);
					var objectN:DisplayObject = playerAvatar.currentRoom.getChildAt(n); 	
					
					if (objectI.y != 0 && objectN.y != 0)
					{
						if (objectI.y + objectI.height > objectN.y + objectN.height)
						{
							playerAvatar.currentRoom.swapChildrenAt(i, n);
						}
					}
				}
			}
			
			// objArray.sortOn('y', Array.DESCENDING);
			
			/*
			for (var n:int = 0; n < objArray.length; n++)
			{
				roomObject = playerAvatar.currentRoom.getChildAt(n);
				//playerAvatar.currentRoom.removeChild(roomObject);
				playerAvatar.currentRoom.setChildIndex(roomObject, n);
				trace(roomObject.name + " Index: " + n);
			}
			*/
		}
		
		public function keyDownHandler(e:KeyboardEvent):void
		{
			checkLayer();

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