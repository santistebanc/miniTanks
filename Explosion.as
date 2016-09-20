package {
    import flash.display.MovieClip;
    import flash.events.Event;
	import flash.media.Sound;
    public class Explosion extends MovieClip {
		
		public var timespan:int = 20;
		public var timeleft:int = timespan;
		
        public function Explosion(posx:Number, posy:Number):void {
            this.x = posx;
			this.y = posy;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
		
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.ENTER_FRAME, update);
			var mySound:Sound = new exp4(); 
			mySound.play();
		}
		
		private function update(e:Event):void {
			
			if(timeleft == 0) {
				remove();
			}
			
			this.timeleft -= 1;
			
		}
		
		public function remove():void {
				this.removeEventListener(Event.ENTER_FRAME, update);
				this.parent.removeChild(this);
		}
		
    }
}