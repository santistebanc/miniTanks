package {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import DocumentClass;

	public class Mainmenu extends MovieClip {
		
		public function Mainmenu():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			root["getHighscores"]();
			root.addEventListener(DocumentClass.HIGHSCORE_UPDATED, updateHighscoreList);
			this.playbut.addEventListener(MouseEvent.CLICK, onClickPlay);
			nameInput.addEventListener(Event.CHANGE, nameInputChange);
		}
		private function nameInputChange(e:Event){
			root["currentname"] = e.target.text;
		}
		private function updateHighscoreList(e:Event):void {
			var hc = root["highscores"];
			var len = 10;
			if(hc.length<10){
				len = hc.length;
			}
			placeText.text = "";
			nameText.text = "";
			scoreText.text = "";
			for(var i=0;i<len;i++){
				placeText.appendText((i+1)+".\n");
				nameText.appendText(hc[i].name+"\n");
				scoreText.appendText(hc[i].score+"\n");
			}
		}
		private function onClickPlay(e:MouseEvent):void {
			root["loadLevel"]();
			hideMenu();
		}
		public function showMenu():void {
			this.visible = true;
			root["getHighscores"]();
		}
		public function hideMenu():void {
			this.visible = false;
		}
	}
}