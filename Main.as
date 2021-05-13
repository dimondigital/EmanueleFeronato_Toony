package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Main extends Sprite {
		// variable to see which toony I am moving, if any. Starts at null value because
		// I am not moving any toony at the beginning of the game
		private var movingToony:Toony=null;
		
		// timer to handle new toony creation. A new toony will be created every 2 seconds
		private var theTimer:Timer=new Timer(2000);
		
		// vector to manage all toonies
		private var toonyVector:Vector.<Toony>=new Vector.<Toony>();
		
		public function Main() {
			// creation of the four draggable toonies
			for (var i:int=1; i<=4; i++) {
				var toony:Toony =new Toony();
				addChild(toony);
				toony.gotoAndStop(i);
				toony.x=i*100;
				toony.y=stage.stageHeight-100;
				toony.buttonMode=true;
				// event to be triggered when the player presses the mouse button over a toony
				toony.addEventListener(MouseEvent.MOUSE_DOWN,toonyClicked);
			}
			// main game loop
			addEventListener(Event.ENTER_FRAME,update);
			// event to be triggered when the player releases the mouse button
			stage.addEventListener(MouseEvent.MOUSE_UP,toonyReleased);
			// event to be triggered avery two seconds, to generate a new toony
			theTimer.addEventListener(TimerEvent.TIMER,newToony);
			// starting the timer
			theTimer.start();
		}
		// what happens when the player presses the mouse on a toony?
		private function toonyClicked(e:MouseEvent):void {
			// if I am not moving any toony...
			if (movingToony==null) {
				// setting the toony I am about to move to the toony I just pressed the mouse on
				movingToony=e.target as Toony;
			}
		}
		// what happens when the player releases the mouse?
		private function toonyReleased(e:MouseEvent):void {
			// if I am moving a toony...
			if (movingToony!=null) {
				// looping through toonies vector
				for (var i:int=toonyVector.length-1; i>=0; i--) {
					// if I am touching a falling toony with the same shape as the toony I am currently moving...
					// (that is: if both toonies are showing the same frame...)
					if (toonyVector[i].hitTestPoint(mouseX,mouseY,true)&&movingToony.currentFrame==toonyVector[i].currentFrame) {
						// the toonies match!! Highlighting the falling toony
						toonyVector[i].alpha=1;
					}
				}
				// putting the moved toony back to its place
				movingToony.y=430;
				movingToony.x=movingToony.currentFrame*100+80;
				// setting the variable which hold the moving toony to null
				// I am not moving any toony now
				movingToony=null;
			}
		}
		// how do I create a new toony?
		private function newToony(e:TimerEvent):void {
			// it's simple: I just create a new Toony instance and place it
			// randomly in the game field with a random frame shown
			var toony:Toony = new Toony();
			addChild(toony);
			toony.x=Math.random()*600+20;
			toony.y=-32;
			toony.gotoAndStop(Math.ceil(Math.random()*4));
			toony.alpha=0.5;
			// pushing the newly created toony into toonies vector
			toonyVector.push(toony);
		}
		// main function
		private function update(e:Event):void {
			// if I am moving a toony...
			if (movingToony!=null) {
				// updating toony position according to mouse position
				movingToony.x=mouseX;
				movingToony.y=mouseY;
			}
			// looping through toonies vector
			for (var i:int=toonyVector.length-1; i>=0; i--) {
				// moving toonies down
				toonyVector[i].y++;
				// removing toonies from the stage if they are too close to the bottom of the stage
				if (toonyVector[i].y>350) {
					removeChild(toonyVector[i]);
					// removing toony item from toonies vector
					toonyVector.splice(i,1);
				}
			}
		}
	}
}