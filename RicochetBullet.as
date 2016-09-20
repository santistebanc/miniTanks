package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import Utils;
	public class RicochetBullet extends Bullet {

		public var timesBounce:int = 10;
		
		private var bounceCount:int = 0;

		public function RicochetBullet(posx:Number, posy:Number, dir:Number):void {
			super(posx,posy,dir);
			this.speed = 30;
			this.timespan = 60;
			this.damage = 5;
			this.gotoAndStop(4);
		}
	}
}