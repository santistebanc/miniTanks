package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	public class scoreNumber extends MovieClip {

		public var time:int = 0;

		public function scoreNumber():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		protected function update(e:Event):void {
			if (time >= 14) {
				this.parent.removeChild(this)
			}else {
				time ++;
			}
		}
		private function onRemovedFromStage(e:Event) {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
	}
}