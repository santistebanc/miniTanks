package {
    import flash.display.MovieClip;
	import flash.events.Event;
    public class LevelManager extends MovieClip {
		
		var time:Number = 0;
		public var tanksingame:Number = 0;
		
		var numenemies:Number = 3;
		var enemyhealth:Number = 20;
		var enemyaccel:Number = 0.3;
		var enemykickback:Number = 30;
		var enemyaccuracy:Number = 15;
		var enemyrotaccel:Number = 1;
		var enemyturretrot:Number = 1;
		var scoretogive:Number = 50;
		
		public function LevelManager():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		public function restart():void {
			time = 0;
			tanksingame = 0;
		}
		private function update(e:Event):void {
			time ++;
			if(time<1000){
				scoretogive = 50;
				numenemies = 3;
				enemyhealth = 20;
				enemyaccel = 0.3;
				enemykickback = 30;
				enemyaccuracy = 15;
				enemyrotaccel = 1;
				enemyturretrot = 1;
			}else if(time<2000){
				scoretogive = 70;
				numenemies = 4;
				enemyhealth = 30;
				enemyaccel = 0.4;
				enemykickback = 30;
				enemyaccuracy = 10;
				enemyrotaccel = 2;
				enemyturretrot = 2;
			}else if(time<3000){
				scoretogive = 100;
				numenemies = 4;
				enemyhealth = 35;
				enemyaccel = 0.5;
				enemykickback = 20;
				enemyaccuracy = 8;
				enemyrotaccel = 2;
				enemyturretrot = 3;
			}else if(time<4000){
				scoretogive = 130;
				numenemies = 5;
				enemyhealth = 45;
				enemyaccel = 0.6;
				enemykickback = 20;
				enemyaccuracy = 5;
				enemyrotaccel = 3;
				enemyturretrot = 4;
			}else if(time<5000){
				scoretogive = 170;
				numenemies = 6;
				enemyhealth = 60;
				enemyaccel = 0.7;
				enemykickback = 15;
				enemyaccuracy = 5;
				enemyrotaccel = 3;
				enemyturretrot = 4;
			}else if(time<6000){
				scoretogive = 200;
				numenemies = 6;
				enemyhealth = 80;
				enemyaccel = 0.8;
				enemykickback = 12;
				enemyaccuracy = 5;
				enemyrotaccel = 4;
				enemyturretrot = 5;
			}else if(time<7000){
				scoretogive = 250;
				numenemies = 7;
				enemyhealth = 100;
				enemyaccel = 0.9;
				enemykickback = 10;
				enemyaccuracy = 4;
				enemyrotaccel = 5;
				enemyturretrot = 5;
			}
			sendWave();
			spawnboxes();
		}
		private function spawnboxes():void {
			if(Math.random()>0.998){
				spawnBox();
			}
		}
		public function sendWave():void {
			if(tanksingame<numenemies){
				if(Math.random()>0.99){
					spawnTank();
				}
			}
		}
		public function spawnTank():void {
			tanksingame ++;
			var enemy = new EnemyTank(enemyhealth,enemyaccel,enemyaccuracy,enemyrotaccel,enemyturretrot,enemykickback,scoretogive);
			var switcher = Math.round(Math.random());
			var switcher2 = Math.round(Math.random());
			enemy.x = (Math.random()*1400-700)*switcher + (switcher2*1500-750)*Math.abs(switcher-1);
			enemy.y = (Math.random()*1200-600)*Math.abs(switcher-1) + (switcher2*1300-650)*switcher;
			root["tanks"].addChild(enemy);
		}
		public function spawnBox():void {
			var box = new Box(Math.random()*1300-650,Math.random()*1100-550);
			root["theitems"].addChild(box);
		}
		protected function onRemovedFromStage(e:Event) {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
    }
}