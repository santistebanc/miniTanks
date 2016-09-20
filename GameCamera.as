package {
	import flash.display.MovieClip;
	import flash.events.Event;
	public class GameCamera extends MovieClip {

		public var roundFactor:int = 10;

		public var cameratarget;
		public var damp:Number = 2;

		public function GameCamera():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		private function update(e:Event):void {
			if (cameratarget) {
				this.x += (cameratarget.x-this.x)/damp;
				this.y += (cameratarget.y-this.y)/damp;
				
				root["battlefield"].x += ((-this.x+400+(400-root.mouseX)/2)-root["battlefield"].x)/10;
				root["battlefield"].y += ((-this.y+300+(300-root.mouseY)/2)-root["battlefield"].y)/10;

				this.x = Math.round(this.x*roundFactor)/roundFactor;
				this.y = Math.round(this.y*roundFactor)/roundFactor;
				root["battlefield"].x = Math.round(root["battlefield"].x*roundFactor)/roundFactor;
				root["battlefield"].y = Math.round(root["battlefield"].y*roundFactor)/roundFactor;
				
				if(root["battlefield"].y > 600){
					root["battlefield"].y = 600;
				}
				
				if(root["battlefield"].y < 0){
					root["battlefield"].y = 0;
				}
				
				if(root["battlefield"].x > 700){
					root["battlefield"].x = 700;
				}
				
				if(root["battlefield"].x < 100){
					root["battlefield"].x = 100;
				}
				
			}
		}
		private function onRemovedFromStage(e:Event):void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
	}
}