package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import communication.FlashLoader;
	import game.Avatar;
	import game.Room;
	import interfaces.RoomInterface;

	/**
	 * ...
	 * @author Nodebay.com
	 */
	
	public class Main extends Sprite 
	{
		public var currentRoom:RoomInterface;
		public var playerAvatar:Avatar;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point.
			// The game starts here!
			
			// Gotta load a room!
			// The room is actually a basic structure: it's a collection of avatars (one of
			// which is the main player's), and a background image.
			
			playerAvatar = new Avatar();
			playerAvatar.username = "Hunter";
			playerAvatar.x = 0;
			playerAvatar.y = 0;
			
			stage.addChild(playerAvatar);
			
			currentRoom = new RoomInterface(playerAvatar);
			stage.addChild(currentRoom);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, currentRoom.keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, currentRoom.keyUpHandler);
		}
	}
}