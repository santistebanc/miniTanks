package {
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Powerbar extends MovieClip {

		public var power:Number = 1;

		public function Powerbar(xpos:Number, ypos:Number):void {
			this.bar.scaleX = power;
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
				this.power = root["player1"].timeforweapon/root["player1"].maxpow;
				this.bar.scaleX = power;
			}
		}
		private function onRemoved(e:Event):void {
			this.removeEventListener(Event.REMOVED, onRemoved);
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
	}
}