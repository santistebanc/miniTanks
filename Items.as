package {
    import flash.display.MovieClip;
	import flash.events.Event;
    public class Items extends MovieClip {
		
		public function Items():void {
        }
		
		public function clear():void {
			for (var i = this.numChildren-1; i>=0; i--) {
				this.removeChildAt(i);
			}
        }
		
    }
}