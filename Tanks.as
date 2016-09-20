package {
    import flash.display.MovieClip;
	import flash.events.Event;
    public class Tanks extends MovieClip {
		
		public function Tanks():void {
        }
		
		public function clear():void {
			for (var i = this.numChildren-1; i>=0; i--) {
				this.removeChildAt(i);
			}
        }
		
    }
}