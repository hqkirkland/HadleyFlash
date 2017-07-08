package communication
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Nodebay.com
	 */
	
	public class FlashLoader extends EventDispatcher
	{
		public var fileLoader:Loader;
		public var fileReady:Boolean = false;
		
		private var fileRequest:URLRequest;
		
		private var swfName:String;
		private var assetName:String;
		
		public function FlashLoader(_swfName:String, _assetName:String) 
		{
			swfName = _swfName;
			assetName = _assetName;
			
			fileRequest = new URLRequest("../Assets/SWF/" + swfName + ".swf");
			
			fileLoader = new Loader();
			fileLoader.load(fileRequest);
			fileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, requestComplete);
			fileLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, requestError);
		}
		
		public function requestComplete(e:Event):void
		{
			trace("Download complete: " + fileRequest.url);
			removeEventListener(Event.COMPLETE, requestComplete);
			this.dispatchEvent(new LoadEvent(fileLoader, swfName, LoadEvent.FILE_DOWNLOADED));
		}
		
		public function requestError(e:IOErrorEvent):void
		{
			this.dispatchEvent(new LoadEvent(fileLoader, swfName, LoadEvent.FILE_DOWNLOADED));
		}
		
		public function selectSprite(assetName:String):Sprite
		{
			var assetClass:Class = fileLoader.contentLoaderInfo.applicationDomain.getDefinition(assetName) as Class;
			return new assetClass();
		}
		
	}

}