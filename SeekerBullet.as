package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import Utils;
	import BulletCrash;
	import Bullet;
	public class SeekerBullet extends Bullet {

		public var distSeek:Number = 200;

		public function SeekerBullet(posx:Number, posy:Number, dir:Number):void {
			super(posx,posy,dir);
			this.speed = 15;
			this.timespan = 200;
			this.damage = 20;
			this.gotoAndStop(3);
		}
		protected override function update(e:Event):void {
			checkDistance();
			super.update(e);
		}
		public function checkDistance():void {
			var enemies;
			if (own == root["player1"]) {
				enemies = Utils.childrenToArray(root["tanks"]);
				for (var a:Number=0; a < enemies.length; a++){
					if (enemies[a] == root["player1"])
					{
						enemies.splice(a, 1);
					}               
				}
			}else{
				enemies = [root["player1"]];
			}
			var objective;
			var mindist;
			for (var i=0; i<enemies.length; i++) {
				var difx = enemies[i].x-this.x;
				var dify = enemies[i].y-this.y;
				var dist = Math.sqrt(difx*difx+dify*dify);
				if(dist<distSeek && (mindist == null || dist<mindist)){
					mindist = dist;
					objective = enemies[i];
				}
			}
			if(objective != null){
				trace(objective);
				var targetAngle = (Math.atan2(this.x-objective.x,-(this.y-objective.y))*180/Math.PI);
				var realdifangle = Utils.angleDif(this.rotation,targetAngle);
				if (realdifangle > 1) {
					this.rotation -= 5;
				} else if (realdifangle < -1) {
					this.rotation += 5;
				}
			}
		}
	}
}