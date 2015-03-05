package project.objects
{
	import project.render.IRenderer;
	
	public class Explosion extends ScreenObject
	{
		
		protected var ticksToLive:int = 16;
		
		public function Explosion(renderer:IRenderer)
		{
			super(renderer);
		}
		
		override public function tick():void
		{
			y-=5;
			ticksToLive--;
			
			renderer.render(x, y);
			
			if(ticksToLive == 0)
			{
				dispose();
			}
		}
	}
}