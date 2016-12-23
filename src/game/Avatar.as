package game
{
	import communication.FlashLoader;
	import communication.LoadEvent;
	import flash.utils.Timer;
	
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Nodebay.com
	 */
	
	public class Avatar extends Sprite
	{
		public var username:String;
		public var country:String;
		
		// The state the avatar is currently in.
		// 1: idle, 2: walking, 3: sitting, 4: holding
		public var action:uint;
		
		// The array of figure item names for each part.
		public var itemArray:Array;
		
		// The rendered spritesheet with all action/direction frames.
		public var spritesheetBmp:Bitmap;
		
		// The keys currently triggered.
		public var keysTriggered:Object = {north: false, south: false, east: false, west: false};
		
		// The backup of the triggered keys, used if going idle.
		public var previousKeys:Object = {north: false, south: false, east: false, west: false};
		
		// The current animation frame that the user is in.
		public var currentFrame:uint;
		
		// The current X movement speed of the sprite.
		public var currentSpeedX:uint;
		
		// The current Y movement speed of the sprite.
		public var currentSpeedY:uint;
		
		// The cache of all loaded bitmap objects.
		private static var itemCache:Object;
		
		// Point specifying the x and y coords of pixel.
		private static const zeroPoint:Point = new Point(0, 0);
		
		// Rectangle to select entire spritesheet.
		private static const itemRect:Rectangle = new Rectangle(0, 0, 1722, 68);
		
		// Rectangle to select frame from spritesheet.
		private static const frameRect:Rectangle = new Rectangle(0, 0, 41, 68);
		
		// Structure of spritesheet.
		private static var keyFrames:Object = 
		{ 
			idle: { north:[0, 0], northeast:[1, 1], east:[2, 2], southeast:[3, 3], south:[4, 4] }, 
			walk: { north:[5, 10], northeast:[11, 16], east:[17, 22], southeast:[23, 28], south:[29, 34] } 
		}
		
		public function Avatar()
		{
			if (itemCache == null)
			{
				itemCache = new Object();
			}
			
			var frameTicker:Timer = new Timer(1000 / 9, 0);
			frameTicker.start();
			
			itemArray = new Array();
			itemArray[0] = "MaleBody";
			itemArray[1] = "Shoes";
			itemArray[2] = "Jeans";
			itemArray[3] = "Overcoat";
			itemArray[4] = "Face1";
			itemArray[5] = "Hair";
			itemArray[6] = "Glasses";
			itemArray[7] = "Hat";
			
			spritesheetBmp = new Bitmap(new BitmapData(1722, 68, true));
			itemArray.forEach(loadItem, null);
			
			this.scrollRect = frameRect;
			
			addEventListener(Event.EXIT_FRAME, doMovement);
			frameTicker.addEventListener(TimerEvent.TIMER, checkAction);
		}
		
		private function loadItem(itemName:String, index:int, itemNameArray:Array):void
		{
			// Nothing to load?			
			if (itemName == null)
			{
				return;
			}
			
			// Is the item cached?
			if (itemIsCached(itemName))
			{
				assembleAvatar();
				return;
			}
			
			var swfLoader:FlashLoader = new FlashLoader(itemName, itemName);
			swfLoader.addEventListener(LoadEvent.FILE_DOWNLOADED, prepareItem);
		}
		
		private function prepareItem(e:LoadEvent = null):void
		{
			e.target.removeEventListener(LoadEvent.FILE_DOWNLOADED, prepareItem);
			
			var indexOfItem:int = itemArray.indexOf(e.fileName);
			
			if (indexOfItem == -1)
			{
				return;
			}
			
			var itemBitmap:Bitmap = new Bitmap(new BitmapData(1722, 68, true, 0x0));
			itemBitmap.bitmapData.draw(e.assetLoader.content);
			itemBitmap.bitmapData.threshold(itemBitmap.bitmapData, itemRect, zeroPoint, "==", 0xFF00FF00);
			itemBitmap.bitmapData.threshold(itemBitmap.bitmapData, itemRect, zeroPoint, "==", 0xFFFF0000);
			
			itemCache[itemArray[indexOfItem]] = itemBitmap;
			trace(itemArray[indexOfItem] + " loaded into the cache..");
			
			if (avatarItemsReady())
			{
				assembleAvatar();
			}
		}
		
		private function avatarItemsReady():Boolean
		{
			return itemArray.every(itemIsCached, null);
		}
		
		private function itemIsCached(itemName:String, index:int = 0, itemNameArray:Array = null):Boolean
		{
			if (itemName == null)
			{
				return true;
			}
			
			if (itemCache[itemName] != null)
			{
				return true;
			}
			
			if (typeof(itemCache[itemName]) == typeof(spritesheetBmp))
			{
				return true;
			}
			
			return false;
		}
		
		// This is the function that layers all of the bitmaps on top of each other.
		// When an appearance changes, we assemble a new spritesheet.
		public function assembleAvatar():void
		{
			spritesheetBmp.bitmapData.dispose();
			spritesheetBmp = new Bitmap(new BitmapData(1722, 68, true));
			
			for (var i:int = 0; i < itemArray.length; i++)
			{
				// Make sure it's not a string. Or still BitmapData.
				if (itemIsCached(itemArray[i]))
				{
					spritesheetBmp.bitmapData.copyPixels(itemCache[itemArray[i]].bitmapData, itemRect, zeroPoint, null, null, true);
				}
			}
			
			addChild(spritesheetBmp);
		}
		
		// Inverts the image horizontally. Necessary when going left, because there's no spritesheet.
		// Credits to: payam_sbr
		// http://stackoverflow.com/users/5862335/payam-sbr
		private function flipSheet(west:Boolean):void
		{
			if (west)
			{
				if (this.scaleX != -1)
				{
					this.scaleX = -1;
					this.x += 41; // Comment this line to see what happens without this fix.
				}
			}
			
			else
			{
				if (this.scaleX != 1)
				{
					this.scaleX = 1;
					this.x -= 41; // Comment this line to see what happens without this fix.
				}
			}
		}
		
		private function doMovement(e:Event):void
		{
			if (keysTriggered.north)
			{
				// If South is the ONLY key down, the speed should be symetrical to x.
				if (!keysTriggered.east && !keysTriggered.west)
				{
					this.y -= currentSpeedX;
				}
				
				else
				{
					this.y -= currentSpeedY;
				}
			}
			
			else if (keysTriggered.south)
			{
				// If South is the ONLY key down, the speed should be symetrical to x.
				if (!keysTriggered.east && !keysTriggered.west)
				{
					this.y += currentSpeedX; 
				}
				
				else
				{
					this.y += currentSpeedY;
				}
			}
			
			if (keysTriggered.west)
			{
				this.x -= currentSpeedX;
			}
			
			else if (keysTriggered.east)
			{
				this.x += currentSpeedX;
			
			}
		}
		
		// Checks and then animates avatar accordingly.
		// Credits to: payam_sbr
		// http://stackoverflow.com/users/5862335/payam-sbr
		private function checkAction(e:TimerEvent):void
		{			
			// Walk animation tester.
			if (keysTriggered.north && keysTriggered.west)
			{ animate(keyFrames.walk.northeast); flipSheet(true); }
			
			else if (keysTriggered.north && keysTriggered.east)
			{ animate(keyFrames.walk.northeast); flipSheet(false); }
			
			else if (keysTriggered.south && keysTriggered.west)
			{ animate(keyFrames.walk.southeast); flipSheet(true); }
			
			else if (keysTriggered.south && keysTriggered.east)
			{ animate(keyFrames.walk.southeast); flipSheet(false); }
			
			else if (keysTriggered.north)
			{ animate(keyFrames.walk.north); flipSheet(false); }
			
			else if (keysTriggered.south)
			{ animate(keyFrames.walk.south); flipSheet(false); }
			
			else if (keysTriggered.west)
			{ animate(keyFrames.walk.east); flipSheet(true); }
			
			else if (keysTriggered.east)
			{ animate(keyFrames.walk.east); flipSheet(false); }
			
			else
			{ 
				// If character doesn't move, play idle animation.
				// Sort previous keyboard stats to determine which direction one should be idle.
				if (previousKeys.north && previousKeys.west)
				{ animate(keyFrames.idle.northeast); flipSheet(true); }
				
				else if (previousKeys.north && previousKeys.east)
				{ animate(keyFrames.idle.northeast); flipSheet(false); }
				
				else if (previousKeys.south && previousKeys.west)
				{ animate(keyFrames.idle.southeast); flipSheet(true); }
				
				else if (previousKeys.south && previousKeys.east)
				{ animate(keyFrames.idle.southeast); flipSheet(false); }
				
				else if (previousKeys.north)
				{ animate(keyFrames.idle.north); flipSheet(false); }
				
				else if (previousKeys.south)
				{ animate(keyFrames.idle.south); flipSheet(false); }
				
				else if (previousKeys.west)
				{ animate(keyFrames.idle.east); flipSheet(true); }
				
				else if (previousKeys.east)
				{ animate(keyFrames.idle.east); flipSheet(false); }
			}
			
			// Update previousKeys.
			previousKeys.north = keysTriggered.north;
			previousKeys.south = keysTriggered.south;
			previousKeys.east = keysTriggered.east;
			previousKeys.west = keysTriggered.west;
			
		}
		
		// Animates the avatar's action.
		// Credits to: payam_sbr
		// http://stackoverflow.com/users/5862335/payam-sbr
		private function animate(currentKeyFrameSet:Array):void 
		{
			
			// Just called with a keyframe of direction (each frame),
			// If keyframe is already playing, it just moved to next frame and got updated (or initial frame of loop)
			// Otherwise, just moved to begining frame of new keyframe
			
			if (currentFrame >= currentKeyFrameSet[0] && currentFrame <= currentKeyFrameSet[1]) 
			{
				currentFrame++;
				
				if (currentFrame > currentKeyFrameSet[1])
				{
					// Play frame.
					currentFrame = currentKeyFrameSet[0];
				}
			}
			
			else
			{
				// Play keyframe.
				currentFrame = currentKeyFrameSet[0];
			}
			
			// Move Spritesheet inside character Sprite (this)
			spritesheetBmp.x = -1 * currentFrame * this.width;
		}
	}
}