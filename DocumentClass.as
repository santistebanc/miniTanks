package {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import com.adobe.serialization.json.JSON;
	import HeroTank;
	import Walls;
	import Tanks;
	import Crosshair;
	import Terrain;
	import Battlefield;
	import GameCamera;
	import Messagebar;
	import Mainmenu;
	import LevelManager;
	import Items;
	public class DocumentClass extends MovieClip {
		
		
		
		public var highscores:Array;
		
		public static const HIGHSCORE_UPDATED:String = "highscoreUpdated";
		
		public var currentname:String = "Anonymous";
		public var currentscore:Number = 0;

		public var mainmenu:Mainmenu;
		
		public var lifebar:Lifebar;
		public var powerbar:Powerbar;
		public var player1:HeroTank;
		public var crosshair:Crosshair;
		public var walls:Walls;
		public var tanks:Tanks;
		public var terrain:Terrain;
		public var battlefield:Battlefield;
		public var maincamera:GameCamera;
		public var messagebar:Messagebar;
		public var levelmanager:LevelManager;
		public var scoretext:scoreText;
		public var theitems:Items;
		
		public var music:SoundChannel = new SoundChannel();
		
		private var gm:GameMask;
		
		private var tune1:Sound = new m1();
		private var tune2:Sound = new m2();

		public function DocumentClass():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void {
			mainmenu = new Mainmenu();
			addChild(mainmenu);
			gm = new GameMask();
			addChild(gm);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			music = tune1.play();
		}
		public function loadLevel() {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, reportKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,reportMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,reportMouseUp);
			Mouse.hide();
			battlefield = new Battlefield();
			walls = new Walls();
			tanks = new Tanks();
			terrain = new Terrain();
			maincamera = new GameCamera();
			lifebar = new Lifebar(15,20);
			powerbar = new Powerbar(15,37.5);
			messagebar = new Messagebar();
			crosshair = new Crosshair();
			levelmanager = new LevelManager();
			scoretext = new scoreText();
			theitems = new Items();
			addChild(battlefield);
			battlefield.addChild(walls);
			battlefield.addChild(theitems);
			battlefield.addChild(tanks);
			battlefield.addChildAt(terrain,0);
			battlefield.addChild(maincamera);
			addChild(lifebar);
			addChild(powerbar);
			addChild(messagebar);
			addChild(crosshair);
			addChild(levelmanager);
			addChild(scoretext);
			walls.drawWalls();
			resetLevel();
			this.setChildIndex(gm, this.numChildren-1);
		}
		public function resetLevel() {
			currentscore = 0;
			theitems.clear();
			tanks.clear();
			levelmanager.restart();
			player1 = new HeroTank(100,0.5,1,2,20);
			player1.x = 0;
			player1.y = 0;
			tanks.addChild(player1);

			maincamera.cameratarget = player1;
			player1.goMouse = true;
			music.stop();
			music = tune2.play();
		}
		public function exitToMainmenu() {
			Mouse.show();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, reportKeyUp);
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,reportMouseDown);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,reportMouseUp);
			removeChild(battlefield);
			removeChild(lifebar);
			removeChild(powerbar);
			removeChild(messagebar);
			removeChild(crosshair);
			removeChild(levelmanager);
			removeChild(scoretext);
			music.stop();
			music = tune1.play();
			mainmenu.showMenu();
		}
		public function getHighscores():void {
			var req:URLRequest = new URLRequest("http://webuser.hs-furtwangen.de/~santiste/2d/Game/get.php");
			var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
			req.data = new URLVariables("cache=no+cache");
        	req.requestHeaders.push(header);
			req.method = URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, receivedHighscores);
			loader.load(req);
		}
		public function saveHighscore(name:String, score:int):void {
			var req:URLRequest = new URLRequest("http://webuser.hs-furtwangen.de/~santiste/2d/Game/post.php");
			var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
        	req.requestHeaders.push(header);
			req.method = URLRequestMethod.POST;
			var variables:URLVariables = new URLVariables("cache=no+cache");
			variables["name"] = name;
			variables["score"] = score;
			req.data = variables;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, savedHighscore);
			loader.load(req);
		}
		private function receivedHighscores(e:Event):void {
			highscores = JSON.decode(e.target.data);
			highscores.sortOn("score", Array.NUMERIC);
			highscores.reverse();
			dispatchEvent(new Event(HIGHSCORE_UPDATED));
		}
		private function savedHighscore(e:Event):void {
			//saved
		}
		private function reportKeyDown(e:KeyboardEvent):void {

			switch (e.keyCode) {
				case Keyboard.LEFT :
				case 65 :
					player1.goLeft = true;
					break;
				case Keyboard.RIGHT :
				case 68 :
					player1.goRight = true;
					break;
				case Keyboard.UP :
				case 87 :
					player1.goForward = true;
					break;
				case Keyboard.DOWN :
				case 83 :
					player1.goBack = true;
					break;
				case Keyboard.SPACE :
					player1.goS = true;
					break;
			}
		}
		private function reportKeyUp(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.LEFT :
				case 65 :
					player1.goLeft = false;
					break;
				case Keyboard.RIGHT :
				case 68 :
					player1.goRight = false;
					break;
				case Keyboard.UP :
				case 87 :
					player1.goForward = false;
					break;
				case Keyboard.DOWN :
				case 83 :
					player1.goBack = false;
					break;
				case Keyboard.SPACE :
					player1.goS = false;
					break;
			}
		}
		private function reportMouseDown(e:MouseEvent):void {
			player1.goShoot = true;
		}
		private function reportMouseUp(e:MouseEvent):void {
			player1.goShoot = false;
		}
	}
}