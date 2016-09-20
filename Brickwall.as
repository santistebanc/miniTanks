package {
    import flash.display.MovieClip;
    import flash.events.Event;
	import flash.geom.Point;
	import Segment;
	import Dot;
    public class Brickwall extends MovieClip {
		
		public function Brickwall():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
	
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			var bounds = this.getBounds(this);
			var aglobal1 = this.localToGlobal(bounds.topLeft);
			var aglobal2 = this.localToGlobal(bounds.topLeft.add(new Point(bounds.width,0)));
			var aglobal3 = this.localToGlobal(bounds.bottomRight.add(new Point(-bounds.width,0)));
			var aglobal4 = this.localToGlobal(bounds.bottomRight);
			
			var global1 = root["battlefield"].globalToLocal(aglobal1);
			var global2 = root["battlefield"].globalToLocal(aglobal2);
			var global3 = root["battlefield"].globalToLocal(aglobal3);
			var global4 = root["battlefield"].globalToLocal(aglobal4);
			
			var up = new Segment(new Dot(global1.x,global1.y),new Dot(global2.x,global2.y));
			var down = new Segment(new Dot(global3.x,global3.y),new Dot(global4.x,global4.y));
			var left = new Segment(new Dot(global1.x,global1.y),new Dot(global3.x,global3.y));
			var right = new Segment(new Dot(global2.x,global2.y),new Dot(global4.x,global4.y));
			root["walls"].addChild(up);
			root["walls"].addChild(down);
			root["walls"].addChild(left);
			root["walls"].addChild(right);
		}
    }
}