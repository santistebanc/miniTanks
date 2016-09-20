﻿package {
    import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
    public class scoreText extends MovieClip {
		
		public function scoreText():void {
			this.x = 780;
			this.y = 30;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		private function update(e:Event):void {
			this.val.text = root["currentscore"];
		}
		private function onRemovedFromStage(e:Event) {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
    }
}