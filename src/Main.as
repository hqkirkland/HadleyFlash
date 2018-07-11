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
		public var walkInterface:RoomInterface;
		public var playerAvatar:Avatar;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// Entry point.
			// The game starts here!
			
			playerAvatar = new Avatar();
			playerAvatar.username = "Hunter";
			
			walkInterface = new RoomInterface(playerAvatar);
			
			stage.addChild(walkInterface);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, walkInterface.keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, walkInterface.keyUpHandler);
			
			addEventListener(Event.ENTER_FRAME, this.frameEntrance);
		}
		
		private function frameEntrance(e:Event):void
		{
			if (walkInterface.roomReady)
			{
				playerAvatar.doMovement();
			}
		}
	}
}