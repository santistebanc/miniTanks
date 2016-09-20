package {
	import Segment;
	import Dot;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	public class Utils {

		public static  function angleDif(ang1:Number,ang2:Number):Number {
			var difangle=ang2 - ang1;
			var realdifangle;
			if (difangle < 180 && ang2 >= ang1) {
				realdifangle=ang2 - ang1;
			}
			if (difangle > -180 && ang2 <= ang1) {
				realdifangle=ang2 - ang1;
			}
			if (difangle >= 180 && ang2 >= ang1) {
				realdifangle=ang2 - ang1 - 360;
			}
			if (difangle <= -180 && ang2 <= ang1) {
				realdifangle=ang2 - ang1 + 360;
			}
			return realdifangle % 360;
		}
		public static  function checkCollision(seg:Segment,arr:Array):Object {
			var wall:Segment;
			var point:Dot;
			var pointdist:Number;
			var rot:Number;

			for (var i:uint=0; i < arr.length; i++) {
				var intwall=arr[i];
				var intersection=intwall.intersect(seg);
				if (intersection != null) {
					var difx=intersection.x - seg.p1.x;
					var dify=intersection.y - seg.p1.y;
					var distance=Math.sqrt(difx * difx + dify * dify);
					if (point == null || distance < pointdist) {
						pointdist = distance;
						point = intersection;
						wall = intwall;
						var norm=wall.normal();
						var segangle=Math.atan2(seg.p2.x - seg.p1.x,- seg.p2.y + seg.p1.y) * 180 / Math.PI;
						var normangle=Math.atan2(norm.x,- norm.y) * 180 / Math.PI;
						if (Math.abs(Utils.angleDif(segangle,normangle)) > 90) {
							rot=normangle;
						} else {
							rot=normangle + 180;
						}
					}
				}
			}
			var obj=new Object  ;
			obj["dot"]=point;
			obj["dist"]=pointdist;
			obj["wall"]=wall;
			obj["normal"]=rot;

			return obj;
		}
		public static  function frameOfReference(point:Point,current:DisplayObject,desired:DisplayObject):Point {
			return desired.globalToLocal(current.localToGlobal(point));
		}
		public static  function childrenToArray(obj:DisplayObjectContainer):Array {
			var children:Array=[];
			for (var i:uint=0; i < obj.numChildren; i++) {
				children.push(obj.getChildAt(i));
			}
			return children;
		}
	}
}