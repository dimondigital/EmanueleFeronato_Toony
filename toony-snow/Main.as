package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	public class Main extends Sprite {
		// переменная чтобы увидеть какого туни я двигаю. Начинается с нулевого значения
		//потому что я не двигаю никакого туни в начале игры
		private var movingToony:Toony=null;
		// Таймер запускающий создание нового Туни. Каждый новый Туни будет создаваться 
		// каждые две секунды
		private var theTimer:Timer=new Timer(2000);
		// таймер для запуска снега
		private var SnowTimer=new Timer(250);
		// вектор(почти массив) для управления Туни
		private var toonyVector:Vector.<Toony>=new Vector.<Toony>();
		// внеигровой снег
		private var snow:OutGameSnow =null;
		// вектор для внеигрового снега
		private var snowVector:Vector.<OutGameSnow>= new Vector.<OutGameSnow>();
		public function Main() {
			// создание четырёх перетаскиваемых Туни
			for (var i:int=1; i<=4; i++) { // цикл для размещения перетаскиваемых Туни
				var toony:Toony=new Toony(); // новый Туни из переменной
				addChild(toony); // создание Туни
				toony.gotoAndStop(i); //обращение к МувиКлипу с нужным номером
				toony.x=i*100+80;// размещение Туни по Х
				toony.y=430;// размещение Туни по Y
				toony.buttonMode=true; // Задаёт режим кнопки для спрайта Туни
				// Запуск события, при котором игрок нажимает мышь над спрайтом Туни
				toony.addEventListener(MouseEvent.MOUSE_DOWN,toonyClicked);
			}
			// главный игровой луп
			addEventListener(Event.ENTER_FRAME,update);
			// луп запускающий снег
			stage.addEventListener(Event.ENTER_FRAME, SnowDown);
			// событие при котором игрок отпускает кнопку мыши
			stage.addEventListener(MouseEvent.MOUSE_UP,toonyReleased);
			// событие, которое генерирует нового Туни каждые 2 секунды
			theTimer.addEventListener(TimerEvent.TIMER,newToony);
			// старт таймера
			theTimer.start();
			SnowTimer.addEventListener(TimerEvent.TIMER,newSnow);
			SnowTimer.start();// старт таймера запускающего внеигровой снег
		}
		// Что происходит когда игрок нажимает клавишу мыши ?
		private function toonyClicked(e:MouseEvent):void {
			// Если я НЕ двигаю любого Туни...
			if (movingToony==null) {
				// setting the toony I am about to move to the toony I just pressed the mouse on
				movingToony=e.target as Toony;
			}
		}
		// Что произойдёт, когда я отпущу клавишу мыши?
		private function toonyReleased(e:MouseEvent):void {
			// Если я двигаю туни...
			if (movingToony!=null) {
				// цикл сквозь Туни вектор
				for (var i:int=toonyVector.length-1; i>=0; i--) {
					// Если я трогаю падающий Туни с такой же самой формой как и двугающий Туни
					// (Это означает: оба Туни показывают один и тот же кадр)
					// Если центр падающего Туни совпадает с центром передвигающегося и если их                    // кадры совпадают...
					if (toonyVector[i].hitTestPoint(mouseX,mouseY,true)&&movingToony.                    currentFrame==toonyVector[i].currentFrame) {
						//Туни совпадают !!! Подсветка Туни
						toonyVector[i].alpha=1;
					}
				}
				// положить на место передвиженого Туни
				movingToony.y=430;
				movingToony.x=movingToony.currentFrame*100+80;
				// возврат переменной двигающегося Туни к нулю - 
				// Я сейчас не двигаю Туни
				movingToony=null;
			}
		}
		// Как я создаю нового Туни?
		private function newToony(e:TimerEvent):void {
			// Это просто: Я просто создаю нового Туни и ложу его
			// случайно на игровом поле и в случайном кадре
			var toony:Toony = new Toony();
			addChild(toony);
			toony.x=Math.random()*600+20;
			toony.y=-32;
			toony.gotoAndStop(Math.ceil(Math.random()*4));
			toony.alpha=0.5;
			// засовую нового созданного Туни в вектор
			toonyVector.push(toony);
		}
		// главная функция
		private function update(e:Event):void {
			// Если я двигаю Туни...
			if (movingToony!=null) {
				// соотношение позиции Туни с позицией мыши
				movingToony.x=mouseX;
				movingToony.y=mouseY;
			}
			// зацикливание через вектор Туни
			for (var i:int=toonyVector.length-1; i>=0; i--) {
				// движение Туни вниз
				toonyVector[i].y++;
				//удаление Туни со сцены, если они слишком близко  к низу сцены
				if (toonyVector[i].y>350) {
					removeChild(toonyVector[i]);
					// удаление туни из вектора
					toonyVector.splice(i,1);
				}
			}
		}
		//  луп создающий внеигровой снег
		private function newSnow(e:TimerEvent):void {
			var snow:OutGameSnow = new OutGameSnow();
			addChild(snow);
			snow.x=Math.random()*600+20;
			snow.y=-32;
			snow.gotoAndStop(Math.ceil(Math.random()*4));	
			snow.alpha=1;
			snow.rotate=Math.random;
			snow.size=Math.random;
			// засовую новый снег в вектор
			snowVector.push(snow);
		}
		// луп движущий внеигровой снег вниз
		private function SnowDown(e:Event):void {
			for (var i:int=snowVector.length-1; i>=0; i--) {
				// движение снега вниз
				snowVector[i].y++;
				//удаление снега со сцены, если они слишком близко  к низу сцены
				if (snowVector[i].y>350) {
					removeChild(snowVector[i]);
					// удаление снега из вектора
					snowVector.splice(i,1);
				}
			}
		}
	}
}