package {
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import Utils;
	import Segment;
	import Dot;
	import flash.media.Sound;
	//import Shoot1;
	public class Tank extends MovieClip {

		public var roundFactor:int = 10;
		
		public var timeforweapon:int = 0;

		public var health:int;
		public var maxhealth:int;
		public var selectedWeapon:int = 0;
		public var weapons = new Array();
		public var ammo:int;
		public var accel:Number;
		public var rotateAccel:Number;
		public var turretAccel:Number;
		public var kickback:Number;
		public var originalkickback:Number;
		public var friction:Number = 0.7;
		public var engineFriction:Number = 0.7;
		public var wallbounce:Number = 15;
		public var walls:Array = [];
		public var globalwalls:Array = [];

		protected var forwardSpeed:Number = 0;
		protected var rotationSpeed:Number = 0;
		public var speedX:Number = 0;
		public var speedY:Number = 0;
		protected var kickbackbar:Number = 0;
		
		public var maxpow = 1;

		public static  const HIT_WALL:String = "hitWall";

		public function Tank(health:int, accel:Number, ra:Number, ta:Number, kb:Number):void {
			this.maxhealth = health;
			this.health = health;
			this.accel = accel;
			this.rotateAccel = ra;
			this.turretAccel = ta;
			this.kickback = kb;
			this.originalkickback = kb;
			var bounds = this.base.getBounds(this);

			var up = new Segment(new Dot(bounds.left,bounds.top),new Dot(bounds.right,bounds.top));
			var down = new Segment(new Dot(bounds.left,bounds.bottom),new Dot(bounds.right,bounds.bottom));
			var left = new Segment(new Dot(bounds.left,bounds.top),new Dot(bounds.left,bounds.bottom));
			var right = new Segment(new Dot(bounds.right,bounds.top),new Dot(bounds.right,bounds.bottom));
			this.walls = [up,down,left,right];

			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.addEventListener(Event.ENTER_FRAME, update);
			for (var i=0; i<this.walls.length; i++) {
				this.addChild(this.walls[i]);
			}
		}
		protected function update(e:Event):void {
			
			if(timeforweapon > 0){
				timeforweapon --;
			}else {
				selectedWeapon = 0;
				this.kickback = this.originalkickback;
			}
			
			if (kickbackbar > 0) {
				kickbackbar -= 1;
			}
			this.forwardSpeed *= engineFriction;
			this.rotationSpeed *= engineFriction;

			this.speedX += this.forwardSpeed*Math.sin(this.rotation/180*Math.PI);
			this.speedY += -this.forwardSpeed*Math.cos(this.rotation/180*Math.PI);
			this.speedX *= this.friction;
			this.speedY *= this.friction;

			this.lwheel.pos += -this.forwardSpeed*2-this.rotationSpeed/2;
			this.rwheel.pos += -this.forwardSpeed*2+this.rotationSpeed/2;

			this.rotation += rotationSpeed;
			this.x += speedX;
			this.y += speedY;

			this.rotation = Math.round(this.rotation*roundFactor)/roundFactor;
			this.x = Math.round(this.x*roundFactor)/roundFactor;
			this.y = Math.round(this.y*roundFactor)/roundFactor;
			
			checkCollision();

		}
		private function checkCollision():void {
			if (root && this.health > 0) {
				var globalup = Segment.translateTo(this.walls[0], this, root["battlefield"]);
				var globaldown = Segment.translateTo(this.walls[1], this, root["battlefield"]);
				var globalleft = Segment.translateTo(this.walls[2], this, root["battlefield"]);
				var globalright = Segment.translateTo(this.walls[3], this, root["battlefield"]);
				this.globalwalls = new Array(globalup,globaldown,globalleft,globalright);



				var walls = Utils.childrenToArray(root["walls"]);
				for (var j=0; j<globalwalls.length; j++) {
					var collisionobj = Utils.checkCollision(globalwalls[j],walls);
					if (collisionobj.dot != null) {
						bounceOff(collisionobj);
					}
				}
				var enemiesplusplayer = Utils.childrenToArray(root["tanks"]);

				for (var i=0; i<enemiesplusplayer.length; i++) {
					if (enemiesplusplayer[i] != this && enemiesplusplayer[i].health > 0) {
						var enemywalls = enemiesplusplayer[i].globalwalls;
						for (var k=0; k<globalwalls.length; k++) {
							var collisionobj2 = Utils.checkCollision(globalwalls[k],enemywalls);
							if (collisionobj2.dot != null) {
								bounceOff(collisionobj2);
							}
						}
					}
				}
			}
		}
		private function bounceOff(collisionobj:Object) {
			var difx = collisionobj.dot.x-this.x;
			var dify = collisionobj.dot.y-this.y;
			var len = Math.sqrt(difx*difx+dify*dify);
			this.speedX -= difx/len*this.wallbounce;
			this.speedY -= dify/len*this.wallbounce;
			this.speedX *= 0.1;
			this.speedY *= 0.1;
			this.rotationSpeed *= 0.1;
			dispatchEvent(new Event(HIT_WALL));
		}
		public function turnBase(dir:int):void {
			this.rotationSpeed += this.rotateAccel*dir;
		}
		public function turnBaseTo(tar:Point):Number {
			var targetAngle = Math.atan2(tar.x-this.x,-tar.y+this.y)*180/Math.PI;
			var realdifangle = Utils.angleDif(this.rotation,targetAngle);
			if (Math.abs(realdifangle) > this.rotateAccel) {
				turnBase(realdifangle/Math.abs(realdifangle));
			}
			return realdifangle;
		}
		public function moveForward(dir:int):void {
			this.forwardSpeed += this.accel*dir;
		}
		public function turnTurret(tarx:Number, tary:Number, extrangle:Number = 0):Number {
			this.turret.accel = this.turretAccel;
			var dispobj:Shape = new Shape();
			dispobj.x = tarx;
			dispobj.y = tary;
			this.turret.tar = dispobj;
			this.turret.extrangle = extrangle;
			this.turret.turn();
			return this.turret.realdifangle;

		}
		public function shoot():void {
			if (kickbackbar <= 0) {
				var therot = this.turret.rotation+this.rotation;
				var bullet:Bullet;
				switch(selectedWeapon){
					case 0:
					bullet = new Bullet(this.x+15*Math.sin(therot/180*Math.PI),this.y-15*Math.cos(therot/180*Math.PI),therot);
					break;
					case 1:
					bullet = new BouncyBullet(this.x+15*Math.sin(therot/180*Math.PI),this.y-15*Math.cos(therot/180*Math.PI),therot);
					break;
					case 2:
					bullet = new RicochetBullet(this.x+15*Math.sin(therot/180*Math.PI),this.y-15*Math.cos(therot/180*Math.PI),therot);
					break;
					case 3:
					bullet = new SeekerBullet(this.x+15*Math.sin(therot/180*Math.PI),this.y-15*Math.cos(therot/180*Math.PI),therot);
					break;
				}
				bullet.own = this;
				root["theitems"].addChild(bullet);
				kickbackbar = kickback;
				if(this.x+root["battlefield"].x>0 && this.x+root["battlefield"].x<800 && this.y+root["battlefield"].y>0 && this.y+root["battlefield"].y<600){
					var mySound:Sound = new shoot2(); 
					mySound.play();
				}
			}
		}
		public function damage(amount:int):void {
			this.health -= amount;
			if (health <= 0) {
				health = 0;
				explode();
			}
		}
		public function changeWeapon():void {


		}
		public function explode():void {
			health = 0;
			root["levelmanager"].tanksingame --;
			var explosion:Explosion = new Explosion(this.x,this.y);
			explosion.scaleX = 2;
			explosion.scaleY = 2;
			this.parent.parent.addChild(explosion);
			this.parent.removeChild(this);
		}
		public function score(amount:int){
			//do nothing
		}
		protected function onRemovedFromStage(e:Event) {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
	}
}