package project.render.displaylist
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import project.assets.SpriteSheet;
	import project.render.IRenderer;
	
	public class DLRenderer implements IRenderer
	{
		
		protected var container:Sprite;
		
		protected var sprite:AnimBitmap;
		
		protected var isDisposed:Boolean = false;
		
		public function DLRenderer(container:Sprite, spritesheet:SpriteSheet)
		{
			
			this.container = container;			
			
			sprite = new AnimBitmap(spritesheet.bitmapData, spritesheet.columns, spritesheet.rows);
			

		}
		
		public function render(x:int, y:int):void
		{

			if( !sprite.parent )
			{			
				container.addChild( sprite );
			}
			else
			{
				sprite.frame++;				
			}
			
			sprite.x = x - sprite.width/2;
			sprite.y = y - sprite.height/2;	
		}
		
		public function dispose():void
		{
			if(sprite.parent)
			{				
				container.removeChild( sprite );				
			}
			isDisposed = true;
		}
	}
}