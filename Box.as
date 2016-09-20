package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import Utils;
	public class Box extends MovieClip {

		public var timespan:int = 2000;
		public var timeleft:int;
		public var perk:int;
		
		private var probabilities:Array = [0,0.8,0.02,0.1,0.05,0.03];

		public function Box(posx:Number, posy:Number, type:int=-1):void {
			this.x = posx;
			this.y = posy;
			if(type >= 0){
				this.perk = type;
			}else{
				var ran = Math.random();
				var cprob = 0;
				for(var i=0;i<probabilities.length;i++){
					cprob = cprob+probabilities[i];
					if(ran < cprob){
						this.perk = i;
						break;
					}
				}
			}
			this.gotoAndStop(this.perk+1);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void {
			timeleft = timespan;
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.addEventListener(Event.ENTER_FRAME, update);
			checkCollision();
		}
		private function update(e:Event):void {
			if (timeleft == 0) {
				this.parent.removeChild(this);
			}else{
				this.timeleft -= 1;
				if(this.hitTestObject(root["player1"].base)){
					take();
				}
			}
		}
		private function checkCollision():void {
			var walls = Utils.childrenToArray(root["walls"]);
			var seg;
			var collisionobj;
				seg = new Segment(new Dot(this.x-15,this.y-15),new Dot(this.x+15,this.y+15));
				collisionobj = Utils.checkCollision(seg,walls);
				if (collisionobj.dot != null) {
					if(collisionobj.dot.x > this.x){
						this.x = collisionobj.dot.x-15;
					}
					if(collisionobj.dot.x < this.x){
						this.x = collisionobj.dot.x+15;
					}
					if(collisionobj.dot.y > this.y){
						this.x = collisionobj.dot.y-15;
					}
					if(collisionobj.dot.y < this.y){
						this.y = collisionobj.dot.y+15;
					}
				}
				seg = new Segment(new Dot(this.x+15,this.y-15),new Dot(this.x-15,this.y+15));
				collisionobj = Utils.checkCollision(seg,walls);
				if (collisionobj.dot != null) {
					if(collisionobj.dot.x > this.x){
						this.x = collisionobj.dot.x-15;
					}
					if(collisionobj.dot.x < this.x){
						this.x = collisionobj.dot.x+15;
					}
					if(collisionobj.dot.y > this.y){
						this.x = collisionobj.dot.y-15;
					}
					if(collisionobj.dot.y < this.y){
						this.y = collisionobj.dot.y+15;
					}
				}
		}
		private function take():void {
			var mySound:Sound = new pick(); 
				mySound.play();
			switch(this.perk){
				case 0:
				//nothing
				break;
				case 1:
				root["player1"].health += 50;
				if (root["player1"].health > root["player1"].maxhealth){
					root["player1"].health = root["player1"].maxhealth;
				}
				break;
				case 2:
				root["player1"].kickback = 10;
				root["player1"].selectedWeapon = 1;
				root["player1"].timeforweapon = 1000;
				root["player1"].maxpow = 1000;
				break;
				case 3:
				root["player1"].accel += 0.1;
				root["player1"].rotateAccel += 0.1;
				root["player1"].turretAccel += 0.2;
				break;
				case 4:
				root["player1"].kickback = 4;
				root["player1"].timeforweapon = 800;
				root["player1"].selectedWeapon = 2;
				root["player1"].maxpow = 800;
				break;
				case 5:
				root["player1"].kickback = 25;
				root["player1"].timeforweapon = 800;
				root["player1"].selectedWeapon = 3;
				root["player1"].maxpow = 800;
				break;
			}
			this.parent.removeChild(this);
		}
		private function onRemovedFromStage(e:Event) {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
	}
}