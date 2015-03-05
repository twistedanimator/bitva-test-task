package project.render.displaylist
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public class AnimBitmap extends Bitmap
	{
		
		protected var columns:int;
		protected var rows:int;
		
		protected var _frame:int = 0;
		
		override public function get width():Number
		{
			return rect.width;
		}
		
		override public function get height():Number
		{
			return rect.height;
		}		
		
		public function get frame():int
		{
			return _frame;
		}
		
		public function set frame(value:int):void
		{
			if(_frame != value)
			{
				if(value>=_totalframes)
				{
					value-=_totalframes
				}
				
				rect.x = int(value%columns) * rect.width;
				rect.y = int(value/columns) * rect.height;
				
				scrollRect = rect;
			
				_frame = value;			
				
			}
		}
		
		protected var _totalframes:int;
		public function get totalframes():int
		{
			return _totalframes;
		}
		
		protected var rect:Rectangle;
		
		public function AnimBitmap(spritesheet:BitmapData=null, columns:int = 1, rows:int = 1)
		{
			super(spritesheet, 'auto', true);
			
			this.columns = columns;
			this.rows = rows;
			
			_totalframes = columns*rows;
			
			rect = new Rectangle(0, 0, spritesheet.width/columns, spritesheet.height/rows);
			
			scrollRect = rect;
		}
		
		
	}
}