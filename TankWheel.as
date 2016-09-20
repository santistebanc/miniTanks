package {
    import flash.display.MovieClip;
    import flash.events.Event;
    public class TankWheel extends MovieClip {
		
		public var pos:Number = 0;
		
		public function TankWheel():void {
			this.addEventListener(Event.ENTER_FRAME, update);
        }
		
		private function update(e:Event):void {
			pos = pos%40;
			this.stripes.y = pos;
		}
		
    }
}