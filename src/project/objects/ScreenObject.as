package project.objects
{
	import project.render.IRenderer;

	public class ScreenObject
	{
		
		public var next:ScreenObject;
		
		public var x:int;
		public var y:int;
		
		public var isDisposed:Boolean;
		
		protected var renderer:IRenderer;
		
		public function ScreenObject(renderer:IRenderer)
		{
			this.renderer = renderer;
		}
		
		public function tick():void
		{
			if(!isDisposed)
			{
				renderer.render(x, y);
			}
		}
		
		protected function dispose():void
		{
			isDisposed = true;	
			renderer.dispose();			
		}
	}
}