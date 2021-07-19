package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var daBg:FlxSprite;
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitCody:FlxSprite;
	var portraitCorbin:FlxSprite;
	var portraitCoby1:FlxSprite;
	var portraitCoby2:FlxSprite;
	var portraitCoby3:FlxSprite;
	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public var queueFade:Bool = false;
	var fadeColor:FlxColor = FlxColor.BLACK;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'conflict':
				FlxG.sound.playMusic(Paths.music('cutsceneMusic','week7'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);
		
		var hasDialog = false;

		daBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		daBg.antialiasing = true;
		add(daBg);
		daBg.visible = true;

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'cultivate':
				bgFade.visible = false;
				box = new FlxSprite(-20, 400);
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('paper/codySpeechBox', 'week7');
				box.animation.addByPrefix('normal', 'speech instance', 12);
				box.animation.addByPrefix('normalOpen', 'speech instance', 12, false);
				box.scale.set(1, 1);

			case 'conflict':
				daBg.visible = false;
				box = new FlxSprite(-20, 400);
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('paper/codySpeechBox', 'week7');
				box.animation.addByPrefix('normal', 'speech instance', 12);
				box.animation.addByPrefix('normalOpen', 'speech instance', 12, false);
				box.scale.set(1, 1);

			case 'clashsterfunk':
				daBg.visible = false;
				box = new FlxSprite(-20, 400);
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('paper/codySpeechBox', 'week7');
				box.animation.addByPrefix('normal', 'speech instance', 12);
				box.animation.addByPrefix('normalOpen', 'speech instance', 12, false);
				box.scale.set(1, 1);

			case 'senpai':
				box = new FlxSprite(-20, 45);
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));

			case 'roses':
				box = new FlxSprite(-20, 45);
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));

			case 'thorns':
				box = new FlxSprite(-20, 45);
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		if (PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='thorns')
		{
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
			portraitLeft.screenCenter(X);
		}
	
		else if (PlayState.SONG.song.toLowerCase()=='cultivate' || PlayState.SONG.song.toLowerCase()=='conflict' || PlayState.SONG.song.toLowerCase()=='clashsterfunk')
		{	
			portraitLeft = new FlxSprite(100, 100).loadGraphic(Paths.image('paper/portraitCody','week7'));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;

			portraitCody = new FlxSprite(100, 100).loadGraphic(Paths.image('paper/portraitCody','week7'));
			portraitCody.updateHitbox();
			portraitCody.scrollFactor.set();
			add(portraitCody);
			portraitCody.visible = false;

			portraitCorbin = new FlxSprite(100, 100).loadGraphic(Paths.image('paper/portraitCody2','week7'));
			portraitCorbin.updateHitbox();
			portraitCorbin.scrollFactor.set();
			add(portraitCorbin);
			portraitCorbin.visible = false;

			portraitCoby1 = new FlxSprite(100, 100).loadGraphic(Paths.image('paper/PortraitCoby','week7'));
			portraitCoby1.updateHitbox();
			portraitCoby1.scrollFactor.set();
			add(portraitCoby1);
			portraitCoby1.visible = false;

			portraitCoby2 = new FlxSprite(100, 100).loadGraphic(Paths.image('paper/PortraitCoby2','week7'));
			portraitCoby2.updateHitbox();
			portraitCoby2.scrollFactor.set();
			add(portraitCoby2);
			portraitCoby2.visible = false;

			portraitCoby3 = new FlxSprite(100, 100).loadGraphic(Paths.image('paper/PortraitCoby3','week7'));
			portraitCoby3.updateHitbox();
			portraitCoby3.scrollFactor.set();
			add(portraitCoby3);
			portraitCoby3.visible = false;
		}
	
		if (PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='thorns')
		{
			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
			handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
			add(handSelect);
		}
	
		else if (PlayState.SONG.song.toLowerCase() =='cultivate' || PlayState.SONG.song.toLowerCase() == 'conflict' || PlayState.SONG.song.toLowerCase() =='clashsterfunk')
		{
			portraitRight = new FlxSprite(700, 175).loadGraphic(Paths.image('paper/bfPortrait','week7'));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.scale.set(0.8,0.8);
			portraitRight.visible = false;
		}
		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);

		box.screenCenter(X);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.1)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var inFade:Bool = true;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true && inFade == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.4);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns'
						|| PlayState.SONG.song.toLowerCase() == 'conflict' || PlayState.SONG.song.toLowerCase() == 'cultivate'
						|| PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						invisiblePortraits();
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				invisiblePortraits();
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'cody':
				invisiblePortraits();
				if (!portraitCody.visible)
				{
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('cody', 'week7'))];
					swagDialogue.color = FlxColor.BLACK;
					dropText.color = FlxColor.GRAY;
					portraitCody.visible = true;
					portraitCody.animation.play('enter');
				}
			case 'corbin':
				invisiblePortraits();
				if (!portraitCorbin.visible)
				{
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('corbin', 'week7'))];
					swagDialogue.color = FlxColor.BLACK;
					dropText.color = FlxColor.GRAY;
					portraitCorbin.visible = true;
					portraitCorbin.animation.play('enter');
				}
			case 'coby1':
				invisiblePortraits();
				if (!portraitCoby1.visible)
				{
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('coby', 'week7'))];
					swagDialogue.color = FlxColor.BLACK;
					dropText.color = FlxColor.GRAY;
					portraitCoby1.visible = true;
					portraitCoby1.animation.play('enter');
				}
			case 'coby2':
				invisiblePortraits();
				if (!portraitCoby2.visible)
				{
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('coby', 'week7'))];
					swagDialogue.color = FlxColor.BLACK;
					dropText.color = FlxColor.GRAY;
					portraitCoby2.visible = true;
					portraitCoby2.animation.play('enter');
				}
			case 'coby3':
				invisiblePortraits();
				if (!portraitCoby3.visible)
				{
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('coby', 'week7'))];
					swagDialogue.color = FlxColor.BLACK;
					dropText.color = FlxColor.GRAY;
					portraitCoby3.visible = true;
					portraitCoby3.animation.play('enter');
				}
			case 'bf':
				invisiblePortraits();
				if (!portraitRight.visible)
				{
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.1)];
					swagDialogue.color = 0xFF3F2021;
					dropText.color = 0xFFD89494;
					FlxG.sound.play(Paths.sound('bf', 'week7'));
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'none':
				invisiblePortraits();
			case 'bghide':
				trace("hidden");
				daBg.visible = false;
			case 'fade':
				inFade = false;
				invisiblePortraits();
				bgFade.alpha = 0;
				var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				black.scrollFactor.set();
				add(black);
				daBg.visible = false;
				dialogueList.remove(dialogueList[0]);
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
						FlxG.sound.playMusic(Paths.music('cutsceneMusic','week7'), 0);
						FlxG.sound.music.fadeIn(1, 0, 0.8);
						black.alpha -= 0.15;
						box.visible = false;
						dropText.visible = false;
						swagDialogue.visible = false;
			
						if (black.alpha > 0)
						{
							tmr.reset(0.3);
						}
						else 
						{
							var num = 1.0;
							new FlxTimer().start(0.6, function(tmr2:FlxTimer)
							{
								num -= 0.15;
								if (num > 0)
								{
									tmr2.reset(0.6);
								}
								else
								{
									box.visible = true;
									dropText.visible = true;
									swagDialogue.visible = true;
									bgFade.visible = true;
									bgFade.alpha = 0.7;
									inFade = true;
									startDialogue();
								}

							});
						}
						
				});

		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}

	function invisiblePortraits():Void
	{
		if(portraitRight.visible)
			portraitRight.visible = false;
		if(portraitLeft.visible)
			portraitLeft.visible = false;
		if(portraitCody.visible)
			portraitCody.visible = false;
		if(portraitCorbin.visible)
			portraitCorbin.visible = false;
		if(portraitCoby1.visible)
			portraitCoby1.visible = false;
		if(portraitCoby2.visible)
			portraitCoby2.visible = false;
		if(portraitCoby3.visible)
			portraitCoby3.visible = false;

		box.visible = true;
		dropText.visible = true;
		swagDialogue.visible = true;
		bgFade.visible = true;
		bgFade.alpha = 0.7;
	}
}


