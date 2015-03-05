package project.assets
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class AssetsProvider
	{
		[Embed(source="image.jpg")]
		protected static const imageClass:Class;
		
		protected var spritesheet:SpriteSheet;
		
		public function AssetsProvider()
		{
		}
		
		public function getSpriteSheet(name:String = null):SpriteSheet
		{
			return spritesheet;
		}
		
		public function init(onInit:Function):void
		{
			var image:BitmapData = new imageClass().bitmapData;						
			
			var bgColor:uint = image.getPixel32(0, 0);		
			var w:int = image.width;
			var h:int = image.height;
			
			var bmd:BitmapData = new BitmapData(w, h, true, 0);
			bmd.copyPixels(image, new Rectangle(0, 0, w, h), new Point);
			
			image.dispose();
			
			bmd.lock();
			for(var i:uint=0; i<w; i++)
			{
				for(var k:uint=0; k<h; k++)
				{
					var d:int = getColorDifference32(bgColor, bmd.getPixel32(i, k));
					if(d <= 10)
					{
						bmd.setPixel32(i, k, 0);
					}
				}
			}
			bmd.unlock();

			spritesheet = new SpriteSheet(bmd, 8, 2);
			
			if(onInit != null)
			{
				onInit();
				onInit = null;
			}
		}
		
		protected function getColorDifference32(color1:uint, color2:uint):int
		{
			var a1:int = (color1 & 0xFF000000) >>> 24;
			var r1:int = (color1 & 0x00FF0000) >>> 16;
			var g1:int = (color1 & 0x0000FF00) >>> 8;
			var b1:int = (color1 & 0x0000FF);
			
			var a2:int = (color2 & 0xFF000000) >>> 24;
			var r2:int = (color2 & 0x00FF0000) >>> 16;
			var g2:int = (color2 & 0x0000FF00) >>> 8;
			var b2:int = (color2 & 0x0000FF);
			
			var a:int = Math.pow((a1-a2), 2);
			var r:int = Math.pow((r1-r2), 2);
			var g:int = Math.pow((g1-g2), 2);
			var b:int = Math.pow((b1-b2), 2);
			
			var d:int = Math.sqrt(a + r + g + b);

			d = Math.floor(d / 510 * 255);
			
			return d;
		}
		
		
	}
}