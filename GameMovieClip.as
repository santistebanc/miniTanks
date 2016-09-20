package {
    import flash.display.MovieClip;
    public class GameMovieClip extends MovieClip {
		
		public function GameMovieClip():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED, onRemoved);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		private function update(e:Event):void {
			//do something
		}
		private function onRemoved(e:Event):void {
			this.removeEventListener(Event.REMOVED, onRemoved);
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
    }
}