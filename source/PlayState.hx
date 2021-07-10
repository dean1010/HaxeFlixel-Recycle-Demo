package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using Math;

/**
 * Recycle Demo
 * A simple example of object pooling and recycling. The group of bullets will 
 * grow by creating new bullets as needed, depending on the maxSize of the group. 
 * Otherwise, if dead bullets are available it will recycle them from the pool. 
 * This way we reuse a small pool of bullets to fire many.
 */
class PlayState extends FlxState
{
	// the bullet group we're recycling from
	var bullets = new FlxTypedGroup<Bullet>();

	// the bullet velocity that we'll calculate when we shoot
	var bulletVelocity = FlxPoint.get(0, 0);

	// the midpoint of the screen is where we'll shoot from
	var fromPt = FlxPoint.get(FlxG.width / 2, FlxG.height / 2);

	// the current bullet we're shooting
	var bullet:Bullet;

	// text display for the status
	var status:FlxText;

	// text display for the instructions
	var instructions:FlxText;

	// how many bullets to shoot at a time
	var shootCount = 5;

	override function create():Void
	{
		// status text
		status = new FlxText(0, 0, FlxG.width, "Shoot Count: " + shootCount + "\nPool Size: 0\nMax Size: 0 (No Limit)\nLiving: 0");
		status.setFormat(null, 16, FlxColor.WHITE, CENTER);

		// instructions text
		instructions = new FlxText(0, FlxG.height - 110, FlxG.width, "ENTER key to Shoot\nPLUS/MINUS keys to set Shoot Count\nARROW keys to set the Max Size\nR key to Reset\nChange the Max Size to see how it affects the Pool Size");
		instructions.setFormat(null, 16, FlxColor.WHITE, CENTER);

		// add the bullets, status and instructions
		add(bullets);
		add(status);
		add(instructions);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// shoot bullet(s) toward a random position
		if (FlxG.keys.justPressed.ENTER)
			for (i in 0...shootCount)
				shoot(FlxG.random.int(0, FlxG.width), FlxG.random.int(0, FlxG.height));

		if (FlxG.keys.justPressed.R)
			FlxG.resetState();

		// set the shootCount with +/- keys
		if (FlxG.keys.anyJustPressed([PLUS, NUMPADPLUS]))
			shootCount = spin(++shootCount, 1, 10);
		else if (FlxG.keys.anyJustPressed([MINUS, NUMPADMINUS]))
			shootCount = spin(--shootCount, 1, 10);

		// set the maxSize from 0 - 100 with arrow keys
		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.RIGHT)
			bullets.maxSize = spin(bullets.maxSize - bullets.maxSize % 10 + 10, 0, 100);
		else if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.LEFT)
			bullets.maxSize = spin(bullets.maxSize - bullets.maxSize % 10 - 10, 0, 100);

		// update the status text
		status.text = "Shoot Count: " + shootCount + 
		"\nPool Size: " + bullets.length + 
		"\nMax Size: " + bullets.maxSize + (bullets.maxSize == 0 ? " (No Limit)": "") + 
		"\nLiving: " + bullets.countLiving();
	}

	function shoot(toX, toY):Void
	{
		// recycle a bullet and reset its position to center it on the screen
		bullet = bullets.recycle(Bullet);
		bullet.reset(fromPt.x - (bullet.width / 2), fromPt.y - (bullet.height / 2));

		// calculate the angle in radians
		var rangle = (toY - fromPt.y).atan2(toX - fromPt.x);
		
		// shoot the bullet by calculating and setting the velocity
		bullet.velocity.set(rangle.cos() * bullet.speed, rangle.sin() * bullet.speed);
	}

	function spin(value:Int, min:Int, max:Int):Int
	{
		if (value < min) return max;
		if (value > max) return min;
		return value;
	}
}
