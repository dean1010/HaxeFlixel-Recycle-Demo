package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	public var speed:Int = 240;

	public function new()
	{
		super();
		makeGraphic(6, 6, FlxColor.CYAN);
	}
	
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!inWorldBounds())
		{
			kill();
		}
	}
}
