package {
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import Utils;
	public class TankTurret extends MovieClip {

		public var tar:DisplayObject;
		public var enableMove:Boolean = true;
		public var accel:Number = 0;
		public var rotationSpeed:Number = 0;
		public var friction:Number = 0.7;
		public var closefriction:Number = 0.2;
		
		public var extrangle:Number = 0;
		
		public var realdifangle:Number = 0;

		private var targetAngle:Number;

		public function TankTurret():void {
			
		}
		public function turn():void {
			if (enableMove) {
				var tarrealglobal:Point = tar.localToGlobal(new Point(root["battlefield"].x,root["battlefield"].y));
				
				var localx = this.parent.globalToLocal(tarrealglobal).x;
				var localy = this.parent.globalToLocal(tarrealglobal).y;
				var targetAngle = (Math.atan2(localx,-localy)*180/Math.PI)+extrangle;
				realdifangle = Utils.angleDif(this.rotation,targetAngle);

				if (Math.abs(realdifangle) <= (Math.abs(this.rotationSpeed)+this.accel)) {
					this.rotationSpeed *= this.closefriction;
					this.rotationSpeed += realdifangle/2;
				} else {
					this.rotationSpeed *= this.friction;
					this.rotationSpeed += this.accel*realdifangle/Math.abs(realdifangle);
				}
				this.rotation += this.rotationSpeed;
			}
		}
	}
}