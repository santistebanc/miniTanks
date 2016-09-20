package {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Dot extends Shape {

		public var displayDraw:Boolean = false;

		public function Dot(thex:Number,they:Number,display:Boolean = false):void {
			this.x = thex;
			this.y = they;
			this.displayDraw = display;
			this.addEventListener(Event.ADDED, onAdded);
		}
		public function onAdded(e:Event) {
			removeEventListener(Event.ADDED, onAdded);
			update();
		}
		public function update() {
			if (displayDraw) {
				this.graphics.clear();
				this.graphics.beginFill(0x990000, 1);
				this.graphics.drawCircle(0,0, 2);
				this.graphics.endFill();
			}
		}
		
		public static function toDot(point:Point){
			return new Dot(point.x,point.y);
		}
		
		public function toPoint():Point {
			return new Point(this.x,this.y);
		}
		
	}
}