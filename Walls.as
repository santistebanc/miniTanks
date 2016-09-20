package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Dot;
	import Segment;
	public class Walls extends MovieClip {

		public function Walls():void {
		}
		public function drawWalls():void {
			var map1 = new Array();
			for(var i = 1;i<=5;i++){
				map1.push([root["terrain"]["p"+i].x,root["terrain"]["p"+i].y]);
				root["terrain"].removeChild(root["terrain"]["p"+i]);
			}
			var map2 = new Array();
			for(var j = 1;j<=4;j++){
				map2.push([root["terrain"]["a"+j].x,root["terrain"]["a"+j].y]);
				root["terrain"].removeChild(root["terrain"]["a"+j]);
			}
			var map3 = new Array();
			for(var k = 1;k<=9;k++){
				map3.push([root["terrain"]["b"+k].x,root["terrain"]["b"+k].y]);
				root["terrain"].removeChild(root["terrain"]["b"+k]);
			}
			drawWall(map1);
			drawWall(map2);
			drawWall(map3);
			
			drawWall([[150,-39],[146.5,-91],[215.9,-93],[379.9,-38.5],[419.9,21.4],[399.9,139.4],[325.9,111],[339.9,11.4]]);
		}
		public function drawWall(map:Array):void {
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0x414628);
			sprite.graphics.moveTo(map[0][0],map[0][1]);
			var seg;
			for(var i = 1;i<map.length;i++){
				sprite.graphics.lineTo(map[i][0],map[i][1]);
				seg = new Segment(new Dot(map[i-1][0],map[i-1][1]),new Dot(map[i][0],map[i][1]));
				this.addChild(seg);
			}
			sprite.graphics.lineTo(map[0][0],map[0][1]);
			sprite.graphics.endFill();
			root["terrain"].addChild(sprite);
			seg = new Segment(new Dot(map[map.length-1][0],map[map.length-1][1]),new Dot(map[0][0],map[0][1]));
			this.addChild(seg);
		}
	}
}