package backeroids.view;

import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import helix.core.HelixSprite;
import helix.data.Config;
using helix.core.HelixSpriteFluentApi;

class Asteroid extends HelixSprite
{
    private static var startingVelocity = Config.get("asteroids").initialVelocity;
    public var totalHealth(default, default):Int = 0;

    public var asteroidSize:Int = 0;
    public var Size:String = "big";

    public function new():Void
    {
        super(null, {width: 60, height: 60, colour: FlxColor.fromString('gray')});
        this.elasticity = Config.get("asteroids").collisionElasticity;
    }

    public function setBigAsteroid():Asteroid
    {
        this.setHealth(Config.get("asteroids").initialHealth);
        this.setScale(1, 1);
        this.Size = "big";

        return this;
    }

    public function setMediumAsteroid():Asteroid
    {
        this.setHealth(Std.int(Config.get("asteroids").initialHealth / 2));
        this.setScale(0.5, 0.5);
        this.Size = "medium";

        return this;
    }

    public function setSmallAsteroid():Asteroid
    {
        this.setHealth(Std.int(Config.get("asteroids").initialHealth / 4));
        this.setScale(0.25, 0.25);
        this.Size = "small";

        return this;
    }

    override public function update(elapsedSeconds:Float):Void
    {
        super.update(elapsedSeconds);
        FlxSpriteUtil.screenWrap(this);
    }

    public function respawn():Void
    {
        this.setBigAsteroid();
        this.processVelocity();
    }

    public function setHealth(health:Int):Void
    {
        this.health = health;
        this.totalHealth = health;
    }

    public function setScale(scaleX:Float, scaleY:Float):Void
    {
        this.scale.set(scaleX, scaleY);
        this.updateHitbox();
    }

    public function damage():Void
    {
        this.health -= 1;
        if (this.health <= 0)
        {
            this.kill();
        }
    }

    private function processVelocity():Void
    {
        if (FlxG.random.float() < 0.5)
		{
			this.processVelocityLeftRight();
		}
		else
		{
			this.processVelocityUpDown();
		}

        this.angularVelocity = (Math.abs(this.velocity.x) + Math.abs(this.velocity.y));
    }

    private function processVelocityUpDown():Void
    {
        if (FlxG.random.float() < 0.5)
        {
            this.y = -this.height;
            this.velocity.y = startingVelocity / 2 + getVelocityRandomPercent();
        }
        else
        {
            this.y = FlxG.height + this.height;
            this.velocity.y = - startingVelocity / 2 + getVelocityRandomPercent();
        }
			
        this.x = FlxG.random.float() * (FlxG.width - width);
        this.velocity.x = getVelocityRandomPercent() * 2 - startingVelocity;
    }

    private function processVelocityLeftRight():Void
    {
        if (FlxG.random.float() < 0.5)
        {
            this.x = -this.width;
            this.velocity.x = startingVelocity / 2 + getVelocityRandomPercent();
        }
        else
        {
            this.x = FlxG.width + this.width;
            this.velocity.x = - startingVelocity / 2 - getVelocityRandomPercent();
        }
			
        this.y = FlxG.random.float() * (FlxG.height - height);
        this.velocity.y = getVelocityRandomPercent() * 2 - startingVelocity;
    }

    private static function getVelocityRandomPercent():Float
    {
        return FlxG.random.float() * startingVelocity;
    }
}