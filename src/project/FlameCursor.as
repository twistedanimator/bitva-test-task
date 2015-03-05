package project
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import project.assets.AssetsProvider;
	import project.objects.Explosion;
	import project.objects.ScreenObject;
	import project.render.IRenderEngine;
	import project.render.a3d.A3DRenderEngine;
	import project.render.displaylist.DLRenderEngine;
	
	public class FlameCursor extends Sprite
	{
		protected var assets:AssetsProvider;		
		
		protected var renderEngine:IRenderEngine;
		protected var engineIndex:int = 0;
		protected var engines:Vector.<IRenderEngine>;
		
		
		protected static const MIN_INTERVAL:int = 50;
		protected static const MAX_INTERVAL:int = 500;
		protected static const DIFF_INTERVAL:int = 50;
		
		protected var lastTime:Number = 0;
		protected var interval:Number = 200;		
		
		protected var objects:ScreenObject;
		
		protected var txtEngineName:TextField;
		
		public function FlameCursor( assets:AssetsProvider )
		{
			this.assets = assets;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
		}
		
		protected function createText():void
		{
			var holder:Sprite = new Sprite;
			holder.filters = [new DropShadowFilter(2)];
			holder.x = holder.y = 10;
			addChild(holder);
			
			var tf:TextFormat = new TextFormat('Verdana', 14, 0xFFFFFF, true);
			var txt:TextField;
			
			txt = new TextField;
			txt.defaultTextFormat = tf;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.multiline = true;
			txt.width = 400;
			txt.text = '+/-\t\t\tизменить скорость генерации\nSPACE\t\tизменить режим рендеринга';
			holder.addChild(txt);
			
			txt = new TextField;
			txt.defaultTextFormat = tf;
			txt.autoSize = TextFieldAutoSize.LEFT;

			txt.y = holder.height+ 10;
			txt.text = 'текущий режим: ';
			holder.addChild(txt);
			
			txtEngineName = new TextField;
			txtEngineName.defaultTextFormat = tf;
			txtEngineName.autoSize = TextFieldAutoSize.LEFT;			
			txtEngineName.y = txt.y;
			txtEngineName.x = txt.width + 10;			
			holder.addChild(txtEngineName);			
		}
		
		protected function onAddedToStage(e:Event):void
		{
			createText();
			
			engines = Vector.<IRenderEngine>([ new A3DRenderEngine(stage, assets), new DLRenderEngine(stage, assets)]);			
			engines[engineIndex].init(onEngineInit);			
		}	
		
		protected function onEngineInit():void
		{
			if(engineIndex == engines.length - 1)
			{
				engineIndex = 0;
				changeEngine();
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
			else
			{
				engineIndex++;
				engines[engineIndex].init(onEngineInit);
			}
		}
		
		protected function changeEngine():void
		{
			renderEngine = engines[engineIndex];
			txtEngineName.text = renderEngine.name;
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.SPACE:
					if(engineIndex == engines.length - 1)
					{
						engineIndex = 0;
					}
					else
					{
						engineIndex++;
					}
					changeEngine();
					break;
				case 187:
					if(interval>MIN_INTERVAL)
					{
						interval-=DIFF_INTERVAL;
					}
					break;
				case 189:
					if(interval<MAX_INTERVAL)
					{
						interval+=DIFF_INTERVAL;
					}
					break;					
			}					
		}
		
		protected function onEnterFrame(e:Event):void
		{
			
			var object:ScreenObject = objects;
			
			var prev:ScreenObject;
			
			
			while(object)
			{
				object.tick();
				
				if(object.isDisposed)
				{
					
					if(prev)
					{
						prev.next = object.next;
					}					
					
					if(object == objects)
					{
						objects = object.next;
					}
					
				}
				
				prev = object;
				object = object.next;
			}
			
			var time:Number = getTimer(); 
			if( (time-lastTime)>interval )
			{
				object = new Explosion( renderEngine.getRenderer() );
				
				object.x = stage.mouseX;
				object.y = stage.mouseY;
				
				object.tick();
				
				object.next = objects;							
				objects = object;				
				
				lastTime = time;

			}			
		}
	}
}