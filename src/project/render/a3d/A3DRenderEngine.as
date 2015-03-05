package project.render.a3d
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.TextureResource;
	
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import project.assets.AssetsProvider;
	import project.assets.SpriteSheet;
	import project.render.IRenderEngine;
	import project.render.IRenderer;
	
	public class A3DRenderEngine implements IRenderEngine
	{
		protected var stage:Stage;
		protected var stage3D:Stage3D;
		
		protected var onInit:Function;
		protected var assets:AssetsProvider;
		protected var materials:Vector.<Material>;		
		
		protected var container:Object3D;
		protected var camera:Camera3D;
		protected var offset:Point;		
		
		public function A3DRenderEngine(stage:Stage, assets:AssetsProvider)
		{
			this.stage = stage;
			this.assets = assets;
		}		
		
		public function getRenderer():IRenderer
		{
			var renderer:A3DRenderer = new A3DRenderer( stage3D, container, offset, materials );			
			return renderer;
		}
		
		public function init(onInit:Function):void
		{
			this.onInit = onInit;
			
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D.requestContext3D();
		}
		
		protected function onContextCreate(e:Event):void
		{
			camera = new Camera3D(0, 1);
			camera.orthographic = true;
			
			container = new Object3D;
			container.addChild(camera);			
			
			camera.view = new View(stage.stageWidth, stage.stageHeight, false, 0x0000FF);
			stage.addChild(camera.view);	
			
			offset = new Point(-camera.view.width/2, -camera.view.height/2);
			
			initMaterials();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResisze);
			
			if(onInit != null)
			{
				onInit();
				onInit = null;
			}
		}
		
		protected function initMaterials():void
		{
			var spritesheet:SpriteSheet = assets.getSpriteSheet();
			
			materials = new Vector.<Material>(spritesheet.frames, true);							
			
			var w:int = spritesheet.frameWidth
			var h:int = spritesheet.frameHeight;			
			
			var rect:Rectangle = new Rectangle(0, 0, w, h);
			var p:Point = new Point;
			var x:int, y:int;
			var colMax:int = spritesheet.columns - 1;
			
			for (var i:int = 0, l:int = spritesheet.frames; i < l; i++) 
			{				
				var bmp:BitmapData = new BitmapData(w, h, true, 0);
				
				rect.x = (i%spritesheet.columns) * spritesheet.frameWidth;
				rect.y = int(i/spritesheet.columns) * spritesheet.frameHeight;
				
				bmp.copyPixels(spritesheet.bitmapData, rect, p);				
				
				var tm:TextureMaterial = new TextureMaterial(new BitmapTextureResource(bmp));
				tm.alphaThreshold = 1;
				materials[i] = tm;
				
				tm.getResources(TextureResource)[0].upload(stage3D.context3D);				
				
				if(i>0 && i%colMax == 0)
				{
					y+=h;
					x = 0;
				}
				else
				{
					x+=w;
				}				
			}
		}
		
		protected function onEnterFrame(e:Event):void
		{
			camera.render(stage3D);
		}
		
		protected function onResisze(e:Event):void
		{
			camera.view.width = stage.stageWidth;
			camera.view.height = stage.stageHeight;
			
			offset.x = -stage.stageWidth/2;
			offset.y = -stage.stageHeight/2;
		}
		
		public function get name():String
		{
			return 'Alternativa3D';
		}


	}
}