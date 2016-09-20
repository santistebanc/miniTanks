package {
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Messagebar extends MovieClip {

		public var life:Number = 1;
		public var wait:int = 30;
		public var time:int = wait;
		public var speed:Number = 0.02;
		private var toappear = false;

		public function Messagebar():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, update);
			this.alpha = 0;
			this.visible = false;
			this.resetbut.addEventListener(MouseEvent.CLICK, onClickReset);
			this.mainmenubut.addEventListener(MouseEvent.CLICK, onClickMainmenu);
		}
		public function appear():void {
			this.visible = true;
			this.toappear = true;
		}
		public function disappear():void {
			this.toappear = false;
			this.visible = false;
			this.alpha = 0;
			this.time = wait;
		}
		private function update(e:Event):void {
			if (toappear && time > 0) {
				time -= 1;
			} else if (toappear && this.alpha < 1) {
				this.alpha += speed;
			}
		}
		private function onClickReset(e:MouseEvent):void {
			disappear();
			root["resetLevel"]();
		}
		private function onClickMainmenu(e:MouseEvent):void {
			disappear();
			root["exitToMainmenu"]();
		}
	}
}