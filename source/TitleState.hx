package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;
//import polymod.Polymod;

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = true;
	static public var soundExt:String = ".ogg";

	

	override public function create():Void
	{
		//Polymod.init({modRoot: "mods", dirs: ['introMod']});

		// DEBUG BULLSHIT

		super.create();
		FlxG.mouse.visible = false;

		FlxG.save.bind('data');

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		KeyBinds.keyCheck();
		PlayerSettings.init();

		Main.fpsDisplay.visible = true;

		startIntro();
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		Conductor.changeBPM(93);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('titleBG'));
		bg.antialiasing = true;
		bg.updateHitbox();
		add(bg);

		var mord:FlxSprite = new FlxSprite().loadGraphic(Paths.image('titleMord'));
		bg.antialiasing = true;
		bg.updateHitbox();
		add(mord);

		var twi:FlxSprite = new FlxSprite().loadGraphic(Paths.image('titleTwi'));
		bg.antialiasing = true;
		bg.updateHitbox();
		add(twi);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas("titleEnter");
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		titleText.alpha = 0;
		// titleText.screenCenter(X);
		add(titleText);

		mord.x += mord.width * 2;
		twi.x -= twi.width * 2;

		FlxTween.tween(mord, {x: 0}, 2, {ease: FlxEase.quintOut});
		FlxTween.tween(twi, {x: 0}, 2, {ease: FlxEase.quintOut});
		FlxTween.tween(titleText, {alpha: 1}, 0.5, {startDelay: 2});
		
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if(initialized){
			Conductor.songPosition = FlxG.sound.music.time;
			// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

			if (FlxG.keys.justPressed.F)
			{
				FlxG.fullscreen = !FlxG.fullscreen;
			}

			var pressedEnter:Bool = controls.ACCEPT || controls.PAUSE;

			if (pressedEnter && !transitioning)
			{
				titleText.animation.play('press');
				Config.configCheck();

				FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt, 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					// Check if version is outdated
					FlxG.switchState(new MainMenuState());
				});
				// FlxG.sound.play('assets/music/titleShoot' + TitleState.soundExt, 0.7);
			}
		}

		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add(curBeat);
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			FlxG.camera.flash(FlxColor.WHITE, 1);
			PlayerSettings.player1.controls.loadKeyBinds();
			Config.configCheck();
			skippedIntro = true;
		}
	}
}
