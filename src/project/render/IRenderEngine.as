package project.render
{
	import project.objects.ScreenObject;

	public interface IRenderEngine
	{
		
		function getRenderer():IRenderer;
		function init(onInit:Function):void;
		function get name():String;
	}
}