package project.assets
{
	import flash.display.BitmapData;

	public class SpriteSheet
	{
		
		public var bitmapData:BitmapData;
		public var columns:int;
		public var rows:int;
		
		public var frames:int;
		public var frameWidth:int;
		public var frameHeight:int;
		
		public function SpriteSheet(bitmapData:BitmapData, columns:int = 1, rows:int = 1)
		{
			this.bitmapData = bitmapData;
			this.columns = columns;
			this.rows = rows;

			
			frames = columns*rows;
			frameWidth = bitmapData.width/columns;
			frameHeight = bitmapData.height/rows;
		}
	}
}
