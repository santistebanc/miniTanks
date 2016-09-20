package {
	import flash.events.Event;
	import flash.geom.Point;
	import flash.filters.ColorMatrixFilter;
	import flash.display.MovieClip;
	import Dot;
	import Segment;
	import Tank;
	import Utils;
	public class EnemyTank extends Tank {

		private var time:int = 0;
		private var ranpoint:Dot = new Dot(0,0,true);
		private var goodpoint:Boolean = false;
		
		public var scoretogive:Number = 50;
		
		private var radarfrequency:int = 30;
		private var radartime:int = 0;

		public var timeOnActivity:int = 0;

		public var discovered:Boolean = false;

		public var lastseen:Dot = new Dot(0,0);
		public var insight:Boolean = false;

		public var gotodist:Number;
		
		private var timewait = 0;
		private var activ = false;
		
		public var accuracy = 0;
		
		private var aimtime = 0;
		private var extraangle = 0;

		public var sightline = new Segment(new Dot(0,0),new Dot(0,0));

		var mColorMatrix:ColorMatrixFilter;
		var mMatrix:Array = [];

		public static  const SEEN:String = "seen";

		public function EnemyTank(health:int, accel:Number, accu:Number, ra:Number, ta:Number, kb:Number, sc:Number):void {
			super(health,accel,ra,ta,kb);
			this.scoretogive = sc;
			this.accuracy = accu;
			// Defines which colors to change. 
			var myMatrix:Array = [0.3,0.6,0.1,0,0,   /* Red */
			                      0.3,0.6,0.1,0,0,   /* Green */
			                      0.3,0.6,0.1,0,0,   /* Blue */
			                      0,0,0,1,0 ];/* Alpha Transparency */

			// Creates a variable with info about the Filter settings. 
			var colorMatrix = new ColorMatrixFilter(myMatrix);

			// Applies the filter to the object named myObject.
			this.filters = [colorMatrix];
		}
		protected override function update(e:Event):void {
			super.update(e);
			playAgressive();
		}
		private function playAgressive():void {
			if(x>-700 && x<700 && y>-600 && y<600 && radartime >= radarfrequency){
				radartime = 0;
				radarPlayer(500,400);
			}
			radartime ++;
			if (insight && root["player1"].health > 0) {
				shootPlayer();
				wanderAround(0.5,90);
			} else if (discovered && root["player1"].health > 0) {
				goToLastSeen();
			} else {
				explore(400);
			}
		}
		private function wanderAround(ran:Number, tim:Number):void {
			if(timewait >= tim){
				timewait = 0;
				if(Math.random()>ran){
					activ = true;
				}else{
					activ = false;
				}
			}if (activ){
				moveRandomly(400,180,this.x-100,this.x+100,this.y-100,this.y+100);
			}
			timewait ++;
		}
		private function goToPoint(point:Point, rotmax:Number):void {
			var mypos = new Point(this.x, this.y);
			var dist = Point.distance(point, mypos);
			if (Math.abs(turnBaseTo(point)) <= rotmax && dist > 5) {
				moveForward(1);
			}
			this.gotodist = dist;
		}
		private function radarPlayer(distx:Number,disty:Number):void {
			addEventListener(EnemyTank.SEEN, seen);
			var player = root["player1"];
			sightline.p1 = new Dot(this.x,this.y);
			sightline.p2 = new Dot(player.x,player.y);
			sightline.update();
			var walls = Utils.childrenToArray(root["walls"]);
			var colobj = Utils.checkCollision(sightline,walls);
			if (colobj.dot == null && Math.abs(player.x-this.x) < distx && Math.abs(player.y-this.y) < disty) {
				lastseen.x = sightline.p2.x;
				lastseen.y = sightline.p2.y;
				lastseen.update();
				insight = true;
				dispatchEvent(new Event(SEEN));
			} else {
				insight = false;
			}
		}
		private function seen(e:Event):void {
			discovered = true;
		}
		private function explore(span:Number):void {
			moveRandomly(span,45,-600,600,-500,500);
			turnTurret(ranpoint.x, ranpoint.y);
		}
		private function moveRandomly(span:Number, rotmax:Number, minx:Number, maxx:Number, miny:Number, maxy:Number):void {
			if(minx<-700){
				minx = -700;
			}
			if(maxx>700){
				maxx = 700;
			}
			if(miny<-600){
				miny = -600;
			}
			if(maxy>600){
				maxy = 600;
			}
			if(!goodpoint || time == 0 || gotodist < 40){
				time = span;
				goodpoint = false;
				ranpoint.x = Math.random()*(maxx-minx)+minx;
				ranpoint.y = Math.random()*(maxy-miny)+miny;
				ranpoint.update();
				var line = new Segment(new Dot(this.x,this.y),ranpoint);
				var walls = Utils.childrenToArray(root["walls"]);
				if (Utils.checkCollision(line,walls).dot == null) {
					goodpoint = true;
				}
			}
			goToPoint(ranpoint.toPoint(), rotmax);
			time -= 1;
		}
		private function hitwall(e:Event):void {
			
		}
		private function shootPlayer():void {
			var player = root["player1"];
			var difx = player.x-this.x;
			var dify = player.y-this.y;
			var dist = Math.sqrt(difx*difx+dify*dify)-15;
			var tim = dist/30;
			var objx = player.x+player.speedX*tim;
			var objy = player.y+player.speedY*tim
			if (aimtime > 15) {
				aimtime = 0;
				extraangle = (Math.random()*accuracy*2)-accuracy;
			}
			aimtime ++;
			if (Math.abs(turnTurret(objx, objy,extraangle)) <= 1) {
				shoot();
			}
		}
		private function goToLastSeen():void {
			turnTurret(lastseen.x, lastseen.y);
			goToPoint(lastseen.toPoint(),90);
			if (gotodist < 20 || timeOnActivity >= 800) {
				timeOnActivity = 0;
				discovered = false;
			}
			timeOnActivity ++;
		}
		override public function explode():void {
			var sn = new scoreNumber();
			sn.val.text = scoretogive;
			sn.x = this.x;
			sn.y = this.y;
			root["battlefield"].addChild(sn);
			root["player1"].score(scoretogive);
			super.explode();
		}
	}
}