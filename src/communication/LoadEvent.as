package communication 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Nodebay.com
	 */
	public class LoadEvent extends Event 
	{
		public static const FILE_DOWNLOADED:String = "downloadComplete";
		public var fileName:String;
		public var assetLoader:Loader;
		
		public function LoadEvent(swfLoader:Loader, swfName:String, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			assetLoader = swfLoader;
			fileName = swfName;
			
			super(type, bubbles, cancelable);
		}
		
		public override function toString():String 
		{
			return formatToString("LoadEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
	
}