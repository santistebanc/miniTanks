package {
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import Dot;
	import Utils;
	public class Segment extends Shape {

		public var p1:Dot;
		public var p2:Dot;
		public var displayDraw:Boolean = false;

		public function Segment(point1:Dot,point2:Dot,display:Boolean = false):void {
			this.p1 = point1;
			this.x = p1.x;
			this.y = p1.y;
			this.p2 = point2;
			this.displayDraw = display;
			this.addEventListener(Event.ADDED, onAdded);
		}
		public function onAdded(e:Event) {
			removeEventListener(Event.ADDED, onAdded);
			update();
		}
		public function update() {
			this.x = p1.x;
			this.y = p1.y;
			if (displayDraw) {
				this.graphics.clear();
				this.graphics.lineStyle(2, 0x000000);
				this.graphics.lineTo(p2.x-this.x, p2.y-this.y);
				this.graphics.moveTo((p2.x-this.x)/2, (p2.y-this.y)/2);
				var norm = this.normal();
				this.graphics.lineStyle(2, 0xff0000);
				this.graphics.lineTo((p2.x-this.x)/2+norm.x*10, (p2.y-this.y)/2+norm.y*10);
			}
		}
		
		public function intersect(seg:Segment,disp:Boolean = false):Dot {
			
			var a:Point = new Point(this.p1.x,this.p1.y);
			var b:Point = new Point(this.p2.x,this.p2.y);
			var c:Point = new Point(seg.p1.x,seg.p1.y);
			var d:Point = new Point(seg.p2.x,seg.p2.y);
			
			var distAB:Number, cos:Number, sin:Number, newX:Number, ABpos:Number;
			if ((a.x == b.x && a.y == b.y) || (c.x == d.x && c.y == d.y)) {
				return null;
			}

			if ( a == c || a == d || b == c || b == d ) {
				return null;
			}

			b = b.clone();
			c = c.clone();
			d = d.clone();

			b.offset( -a.x, -a.y);
			c.offset( -a.x, -a.y);
			d.offset( -a.x, -a.y);
			// a is now considered to be (0,0)

			distAB = b.length;
			cos = b.x / distAB;
			sin = b.y / distAB;

			c = new Point(c.x * cos + c.y * sin, c.y * cos - c.x * sin);
			d = new Point(d.x * cos + d.y * sin, d.y * cos - d.x * sin);

			if ((c.y < 0 && d.y < 0) || (c.y >= 0 && d.y >= 0)) {
				return null;
			}

			ABpos = d.x + (c.x - d.x) * d.y / (d.y - c.y);// what.
			if (ABpos < 0 || ABpos > distAB) {
				return null;
			}

			return new Dot(a.x + ABpos * cos,a.y + ABpos * sin, disp);
		}
		
		public function normal():Point {
			var difx = p2.x-p1.x;
			var dify = p2.y-p1.y;
			var len = Math.sqrt(difx*difx+dify*dify);
			return new Point(-dify/len,difx/len);
		}
		
		public static function translateTo(seg:Segment, current:DisplayObject, desired:DisplayObject):Segment {
			var newp1 = Dot.toDot(Utils.frameOfReference(seg.p1.toPoint(), current, desired));
			var newp2 = Dot.toDot(Utils.frameOfReference(seg.p2.toPoint(), current, desired));
			return new Segment(newp1,newp2);
		}
		
	}
}