/**
 * Copyright nabe ( http://wonderfl.net/user/nabe )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/9eE0
 */

package {
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	
	[SWF( width="800",height="640",frameRate="60",backgroundColor="0xEEEDE3" )]
	

	public class WaterLevel extends Sprite {
		private var cursor_i:MyMask;
		private var cursor_r:MyMask;
		public function WaterLevel():void {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init (e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var water_:Sprite = new MyWater(stage, 100);
			water_.blendMode = BlendMode.SUBTRACT;
			water_.y = 320;

			cursor_i = new_cursor(water_, false);
			cursor_r = new_cursor(water_, true);

			addChild(cursor_i);
			addChild(water_);
			addChild(cursor_r);

			addEventListener(MouseEvent.MOUSE_MOVE, update);
			update(null);
		}
		private function update (e:Event):void {
			cursor_i.x = mouseX;
			const h_:int = 640;
			cursor_i.y = h_ + (mouseY - h_) * 0.4;
			cursor_i.refresh();
			cursor_r.x = mouseX;
			cursor_r.y = mouseY;
			cursor_r.refresh();
		}
		private function new_cursor (water_:Sprite, real_:Boolean):MyMask {
			var original_:Sprite = new MyTorus(300);
			original_.filters = [new ColorMatrixFilter([
				0, 0, 0.25, 0, 0xD0,
				0, 0, 0, 0, 0x70,
				0, 0, 0, 0, 0x70,
				0, 0, 0, 1, 0
			])];
			original_.cacheAsBitmap = true;
			
			var map_:Sprite = new MyTorus(300);
			map_.filters = [new ColorMatrixFilter([
				0, 0, 0, 0, 0,
				0, 0, 0, 0, 0,
				0, 0, 0.1, 0, 0x10,
				0, 0, 0, 1, 0
			])];
			map_.cacheAsBitmap = true;

			if (! real_) map_.scaleY = 0.4;
			return new MyMask(original_.getBounds(original_), original_, map_, water_, real_);
		}
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.Stage;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;


class MyWater extends Sprite {
	

	public function MyWater(stage:Stage, height:int):void {
		var m_:Matrix = new Matrix;
		m_.createGradientBox(100, height, Math.PI * 0.5);
		var g_:Graphics = graphics;
		g_.beginGradientFill(GradientType.LINEAR, [0, 0xFF], null, null, m_);
		g_.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		g_.endFill();
	}
}
class MyTorus extends Sprite {
	[Embed(source="pike.png")]
	private var pike:Class;
	public function MyTorus(radius:int):void {
		var pikea:Bitmap=new pike() as Bitmap
		addChild(pikea);
	//	var m_:Matrix = new Matrix;
		//m_.createGradientBox(radius * 2, radius * 2, 0, -radius, -radius);
	//	var g_:Graphics = graphics;
	//	g_.beginGradientFill(GradientType.RADIAL,
	//		[1, 0x40, 0x80, 0xC0, 0xFF, 0xC0, 0x80, 0x40, 1],
	//		[0, 1, 1, 1, 1, 1, 1, 1, 1],
	//		[0x80, 0x84, 0x8F, 0xA0, 0xC0, 0xE0, 0xF0, 0xFC, 0xFF], m_);
	//	g_.drawCircle(0, 0, radius);
	//	g_.endFill();
		
		
	}
}
class MyMask extends Sprite {
	private var rect_:Rectangle;
	private var original_:Sprite;
	private var map_:Sprite;
	private var water_:Sprite;
	private var work_:BitmapData;
	private var bd_:BitmapData;
	private var m_:Matrix = new Matrix;
	private var o_:Point = new Point;
	private var real_:Boolean;
	public function MyMask(rect:Rectangle, original:Sprite, map:Sprite, water:Sprite, real_arg:Boolean):void {
		rect_ = rect;
		m_.createBox(1, 1, 0, -rect_.left, -rect_.top);
		original_ = original;
		map_ = map;
		water_ = water;
		work_ = new BitmapData(rect_.width, rect_.height, false);
		bd_ = new BitmapData(rect_.width, rect_.height, true);
		var b_:Bitmap = new Bitmap(bd_);
		b_.x = rect_.left;
		b_.y = rect_.top;
		addChild(b_);
		real_ = real_arg;
	}
	public function refresh():void {
		var i_:Matrix = m_.clone();
		if (!real_) i_.scale(1, map_.scaleY);
		var w_:Matrix = m_.clone();
		w_.translate(water_.x - x, water_.y - y + (real_ ? 0 : -0));
		work_.fillRect(work_.rect, 0);
		if (real_) {
			work_.draw(map_, i_);
			work_.draw(water_, w_, null, BlendMode.SUBTRACT);
		} else {
			work_.draw(water_, w_);
			work_.draw(map_, i_, null, BlendMode.SUBTRACT);
		}

		bd_.lock();
		bd_.fillRect(bd_.rect, 0);
		bd_.draw(original_, i_);
		bd_.threshold(work_, work_.rect, o_, "<", 1, 0, 0xFF);
		bd_.unlock();
	}
}
