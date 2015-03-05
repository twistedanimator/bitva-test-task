package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import project.FlameCursor;
	import project.assets.AssetsProvider;
	
	
	[SWF(width="800", height="600", backgroundColor="0x0000FF")]
	public class Main extends Sprite
	{
		protected var assets:AssetsProvider;
		protected var fps:FPS;
	
		public function Main()
		{			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;			
			stage.frameRate = 24;
			
			assets = new AssetsProvider;
			assets.init(onAssetsReady);
			
			addChild( fps = new FPS(stage, 0, 0) );
			fps.y = 20;
			onResize();

		}
		
		protected function onAssetsReady():void
		{			
			addChild( new FlameCursor( assets ) );
		}
		
		protected function onResize(e:Event = null):void
		{
			fps.x = stage.stageWidth - fps.width - 20;
		}


		
	}
}