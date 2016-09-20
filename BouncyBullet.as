package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import Utils;
	import BulletCrash;
	import Bullet;
	public class BouncyBullet extends Bullet {

		public var timesBounce:int = 10;
		
		private var bounceCount:int = 0;

		public function BouncyBullet(posx:Number, posy:Number, dir:Number):void {
			super(posx,posy,dir);
			this.speed = 20;
			this.timespan = 200;
			this.gotoAndStop(2);
		}
		public override function hitwall(rot:Number):void {
			bounce(rot);
		}
		public function bounce(rot:Number):void {
			if(bounceCount >= timesBounce){
				explode(rot);
			}else{
				if(this.x+root["battlefield"].x>0 && this.x+root["battlefield"].x<800 && this.y+root["battlefield"].y>0 && this.y+root["battlefield"].y<600){
				var mySound:Sound = new b1(); 
				mySound.play();
				}
				bounceCount += 1;
				this.rotation = this.rotation+180+Utils.angleDif(this.rotation+180,rot)*2;
			}
		}
	}
}