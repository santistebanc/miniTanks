package {
	import flash.events.Event;
    import Tank;
    public class HeroTank extends Tank {
		
		public var goLeft:Boolean = false;
		public var goRight:Boolean = false;
		public var goForward:Boolean = false;
		public var goBack:Boolean = false;
		public var goMouse:Boolean = false;
		public var goShoot:Boolean = false;
		public var goS:Boolean = false;
		public var goRotateTurret:Boolean = false;

		
        public function HeroTank(health:int, accel:Number, ra:Number, ta:Number, kb:Number):void {
			super(health,accel,ra,ta,kb);
            this.addEventListener(Event.ENTER_FRAME, checkCommands);
        }
		
		private function checkCommands(e:Event):void {
			if(goS){
				explode();
			}
			if(goLeft){
				turnBase(-1);
			}
			if(goRight){
				turnBase(1);
			}
			if(goForward){
				moveForward(1);
			}
			if(goBack){
				moveForward(-1);
			}
			if(goMouse){
				turnTurret(this.parent.mouseX,this.parent.mouseY);
			}
			if(goShoot){
				shoot();
			}
			//keep player inside battlefield
			if(this.x < -700){
				this.speedX = 0;
				this.x = -700;
			}
			if(this.x > 700){
				this.speedX = 0;
				this.x = 700;
			}
			if(this.y < -600){
				this.speedY = 0;
				this.y = -600;
			}
			if(this.y > 600){
				this.speedY = 0;
				this.y = 600;
			}
			
		}
		
		public override function score(amount:int){
			root["currentscore"] += amount;
		}
		
		protected override function onRemovedFromStage(e:Event){
			root["messagebar"].appear();
			root["saveHighscore"](root["currentname"], root["currentscore"]);
			this.removeEventListener(Event.ENTER_FRAME, checkCommands);
			super.onRemovedFromStage(e);
		}
		
		
    }
}