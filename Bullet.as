package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import Utils;
	import BulletCrash;
	public class Bullet extends MovieClip {

		public var own;

		public var speed:Number = 25;
		public var timespan:int = 50;
		public var damage:int = 10;
		public var timeleft:int;

		public function Bullet(posx:Number, posy:Number, dir:Number):void {
			this.x = posx;
			this.y = posy;
			this.gotoAndStop(1);
			this.rotation = dir;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void {
			timeleft = timespan;
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		protected function update(e:Event):void {
			this.x += this.speed*Math.sin(this.rotation/180*Math.PI);
			this.y += -this.speed*Math.cos(this.rotation/180*Math.PI);

			if (timeleft == 0) {
				explode(this.rotation);
			}else {
				this.timeleft -= 1;
				checkCollision();
			}
		}
		private function checkCollision():void {
				var seg = new Segment(new Dot(this.x,this.y),new Dot(this.x+this.speed*Math.sin(this.rotation/180*Math.PI),this.y-this.speed*Math.cos(this.rotation/180*Math.PI)));

				var walls = Utils.childrenToArray(root["walls"]);
				var collisionobj = Utils.checkCollision(seg,walls);
				if (collisionobj.dot != null) {
					this.x = collisionobj.dot.x;
					this.y = collisionobj.dot.y;
					hitwall(collisionobj.normal);
				}
				if (root && root["player1"].health > 0) {
				var enemiesplusplayer = Utils.childrenToArray(root["tanks"]);

				for (var i=0; i<enemiesplusplayer.length; i++) {
					if (enemiesplusplayer[i] != own) {
						var enemywalls = enemiesplusplayer[i].globalwalls;
						var colobj = Utils.checkCollision(seg,enemywalls);
						if (colobj.dot != null) {
							this.x = colobj.dot.x;
							this.y = colobj.dot.y;
							enemiesplusplayer[i].damage(damage);
							explode(colobj.normal);
						}
					}
				}
			}
		}
		public function hitwall(rot:Number):void {
			explode(rot);
		}
		public function explode(rot:Number):void {
			var explosion:BulletCrash = new BulletCrash(this.x,this.y);
			explosion.rotation = rot;
			root["battlefield"].addChild(explosion);
			this.parent.removeChild(this);
		}
		private function onRemovedFromStage(e:Event) {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
	}
}