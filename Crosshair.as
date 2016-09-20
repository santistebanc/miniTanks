package {
    import flash.display.MovieClip;
    import flash.events.Event;
	import flash.events.MouseEvent;
    public class Crosshair extends MovieClip {
		
		public function Crosshair():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
	
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,cursor_update);
		}
		private function cursor_update(e:MouseEvent):void {
				this.x = this.stage.mouseX;
				this.y = this.stage.mouseY;
		}
		private function onRemovedFromStage(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,cursor_update);
		}
		
    }
}