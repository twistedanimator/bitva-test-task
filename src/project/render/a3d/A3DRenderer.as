package project.render.a3d
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.AnimSprite;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.resources.TextureResource;
	
	import flash.display.Stage3D;
	import flash.geom.Point;
	
	import project.render.IRenderer;
	
	public class A3DRenderer implements IRenderer
	{
		protected var stage3D:Stage3D;
		
		protected var container:Object3D;
		protected var offset:Point;
		
		protected var sprite:AnimSprite;
		
		public function A3DRenderer( stage3D:Stage3D, container:Object3D, offset:Point, materials:Vector.<Material>)
		{
			this.stage3D = stage3D;
			this.container = container;
			this.offset = offset;
			
			sprite = new AnimSprite(100, 100, materials, true);	
		}
		
		public function render(x:int, y:int):void
		{
			sprite.x = x + offset.x
			sprite.y = y + offset.y;			
			
			if( !sprite.parent )
			{				
				container.addChild( sprite );
				for each (var resource:Resource in sprite.getResources(true, Geometry)) 
				{
					resource.upload(stage3D.context3D);
					
				}				
			}
			else
			{
				sprite.frame++;
			}		
			
		}
		
		public function dispose():void
		{
			if(sprite.parent)
			{				
				container.removeChild( sprite );
				for each (var resource:Resource in sprite.getResources(true, Geometry)) 
				{
					resource.dispose();
					
				}				
			}
		}
	}
}