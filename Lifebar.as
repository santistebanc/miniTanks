package {
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Lifebar extends MovieClip {

		public var life:Number = 1;

		public function Lifebar(xpos:Number, ypos:Number):void {
			this.bar.scaleX = life;
			this.x = xpos;
			this.y = ypos;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED, onRemoved);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		private function update(e:Event):void {
			if (root["player1"]) {
				this.life = root["player1"].health/root["player1"].maxhealth;
				this.bar.scaleX = life;
			}
		}
		private function onRemoved(e:Event):void {
			this.removeEventListener(Event.REMOVED, onRemoved);
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
	}
}