package project.render.displaylist
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	
	import project.assets.AssetsProvider;
	import project.assets.SpriteSheet;
	import project.render.IRenderEngine;
	import project.render.IRenderer;
	
	public class DLRenderEngine implements IRenderEngine
	{
		
		protected var stage:Stage;
		protected var assets:AssetsProvider;
		
		protected var container:Sprite;
		
		protected var spritesheet:SpriteSheet;
		
		public function DLRenderEngine(stage:Stage, assets:AssetsProvider)
		{   
			this.stage = stage;
			this.assets = assets;
			
			var sheet:SpriteSheet = assets.getSpriteSheet(); 
			
			var frameWidth:int = 100;
			
			var m:Matrix = new Matrix;
			var scale:Number = frameWidth/sheet.frameWidth; 
			m.scale(scale, scale);
			
			var bmd:BitmapData = new BitmapData(frameWidth*sheet.columns, frameWidth*sheet.rows, true, 0);
			bmd.draw(sheet.bitmapData, m);
			
			spritesheet = new SpriteSheet(bmd, sheet.columns, sheet.rows);
			
			container = new Sprite;
			stage.addChild(container);
		}
		
		public function init(onInit:Function):void
		{
			if(onInit != null)
			{
				onInit();
			}
		}

		
		public function getRenderer():IRenderer
		{
			var renderer:DLRenderer = new DLRenderer( container, spritesheet );			
			return renderer;
		}
		
		public function get name():String
		{
			return 'Display List';
		}
	}
}