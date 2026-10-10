import funkin.options.OptionsMenu;
import funkin.menus.credits.CreditsMain;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import funkin.game.PlayState;
import flixel.tweens.FlxEase;
import flixel.math.FlxMath;
import flixel.text.FlxTextBorderStyle;


var fileNames:Array<String> = ["FESTIVAL DAY", "OUT OF TOWN", "[EMPTY]"];
var fileSubLines:Array<String> = ["The Festival", "???", "------------"];
var fileTimes:Array<String> = ["00:01:40", "00:04:39", "--:--"];

var UNSELECTED_COLOR:FlxColor = 0xffbebeca;
var SELECTED_COLOR:FlxColor = FlxColor.WHITE;

var bg:FunkinSprite;
var chapterText:FunkinText;
var selectFileText:FunkinText;

var fileBoxes:Array<FunkinSprite> = [];
var fileNameTexts:Array<FunkinText> = [];
var fileTimeTexts:Array<FunkinText> = [];
var fileTextGroups:Array<Array<FunkinText>> = [];

var optionsText:FunkinText;
var creditsText:FunkinText;

var heart:FunkinSprite;

var messageOpen:Bool = false;
var messageBg:FunkinSprite;
var messageText:FunkinText;


var curRow:Int = 0;
var curFileIndex:Int = 0;
var curBottomIndex:Int = 0;

static var menuShalom:Bool = false;


public static function reset():Void menuShalom = false;

function postCreate() {

	if (!menuShalom){
        FlxG.sound.playMusic(Paths.music('freakyMenu'));
        menuShalom = true;
    }
	
	FlxG.mouse.visible = false;

	bg = new FunkinSprite(0, 0);
	bg.frames = Paths.getSparrowAtlas('main_menu/Background');
	bg.animation.addByPrefix('loop', 'Loop', 3, true);
	bg.animation.play('loop');

	var scale:Float = Math.max(FlxG.width / bg.frameWidth, FlxG.height / bg.frameHeight);
	bg.scale.set(scale, scale);
	bg.alpha = 0.5;
	bg.updateHitbox();
	bg.screenCenter();
	add(bg);

	chapterText = new FunkinText(55, 15, 600, 'CHAPTER 5', 50);
	chapterText.font = Paths.font('8bit_operator.ttf');
	chapterText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2);
	add(chapterText);

	selectFileText = new FunkinText(105, 85, 700, 'Please select a file.', 52);
	selectFileText.font = Paths.font('8bit_operator.ttf');
	selectFileText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2);
	add(selectFileText);

	
	for (i in 0...3) {
		var box:FunkinSprite = new FunkinSprite(0, 0);
		box.loadGraphic(Paths.image('main_menu/Box_Unselect'));
		box.x = (FlxG.width - box.width) / 2;
		box.y = 160 + i * 145;
		add(box);
		fileBoxes.push(box);

		var nameText:FunkinText = new FunkinText(box.x + 75, box.y + 20, box.width - 200, fileNames[i], 35);
		nameText.font = Paths.font('8bit_operator.ttf');
		nameText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2);
		add(nameText);
		fileNameTexts.push(nameText);

		var locationText:FunkinText = new FunkinText(box.x + 75, box.y + 70, box.width - 200, fileSubLines[i], 35);
		locationText.font = Paths.font('8bit_operator.ttf');
		locationText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2);
		add(locationText);
		fileNameTexts.push(locationText);

		var timeText:FunkinText = new FunkinText(box.x + box.width - 245, box.y + 40, 200, fileTimes[i], 45);
		timeText.font = Paths.font('8bit_operator.ttf');
		timeText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2);
		timeText.alignment = 'right';
		add(timeText);
		fileTimeTexts.push(timeText);

		fileTextGroups.push([nameText, locationText, timeText]);
	}

	optionsText = new FunkinText(250, 610, 200, 'Options', 40);
	optionsText.font = Paths.font('8bit_operator.ttf');
	optionsText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2);
	add(optionsText);

	creditsText = new FunkinText(600, 610, 200, 'Credits', 40);
	creditsText.font = Paths.font('8bit_operator.ttf');
	creditsText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2);
	add(creditsText);

	heart = new FunkinSprite(0, 0).loadGraphic(Paths.image('main_menu/Heart'));
	add(heart);

	updateSelectionVisuals(true);
}

function postUpdate(elapsed:Float) {
	if (controls.SWITCHMOD || FlxG.keys.justPressed.SEVEN) {
		if (controls.SWITCHMOD) menuShalom = false;
		persistentUpdate = false;
		persistentDraw = true;
		openSubState(controls.SWITCHMOD ? new ModSwitchMenu() : new EditorPicker());
		return;
	}

	if (messageOpen) {
		if (controls.ACCEPT || controls.BACK)
			closeMessage();
		return;
	}

	if (controls.UP_P)
		moveVertical(-1);
	else if (controls.DOWN_P)
		moveVertical(1);
	else if (controls.LEFT_P)
		moveHorizontal(-1);
	else if (controls.RIGHT_P)
		moveHorizontal(1);
	else if (controls.ACCEPT)
		confirmSelection();
	else if (controls.BACK)
		cancelAction();
}

function moveVertical(dir:Int) {
	if (curRow == 0) {
		var newIndex:Int = curFileIndex + dir;
		if (newIndex < 0)
			return;

		if (newIndex > 2)
			curRow = 1;
		else
			curFileIndex = newIndex;
	} else {
		if (dir < 0) {
			curRow = 0;
			curFileIndex = 2;
		}
	}
	FlxG.sound.play(Paths.sound('menu/scroll'));
	updateSelectionVisuals();
}

function moveHorizontal(dir:Int) {
	if (curRow != 1)
		return;

	curBottomIndex = FlxMath.wrap(curBottomIndex + dir, 0, 1);
	FlxG.sound.play(Paths.sound('menu/scroll'));
	updateSelectionVisuals();
}

function confirmSelection() {
	FlxG.sound.play(Paths.sound('menu/confirm'));

	if (curRow == 0)
		selectFile(curFileIndex);
	else if (curBottomIndex == 0)
		FlxG.switchState(new OptionsMenu());
	else
		FlxG.switchState(new ModState("DRCredits"));
}

function cancelAction() {
	FlxG.sound.play(Paths.sound('menu/cancel'));
}

var songKeys:Array<String> = ["festival-day", "out-of-town"];

function selectFile(index:Int) {
	if (index == 2) {
		FlxG.sound.play(Paths.sound('menu/cancel'));
		return;
	}

	menuShalom = false;

	var songFolder:String = songKeys[index];

	PlayState.loadSong(songFolder, "normal");

	PlayState.isStoryMode = false;
	FlxG.switchState(new PlayState());
}

function updateSelectionVisuals(instant:Bool = false) {
	for (i in 0...fileBoxes.length) {
		var isSelected:Bool = (curRow == 0 && i == curFileIndex);
		fileBoxes[i].loadGraphic(Paths.image(isSelected ? 'main_menu/Box_Selected' : 'main_menu/Box_Unselect'));

		var textColor:FlxColor = isSelected ? SELECTED_COLOR : UNSELECTED_COLOR;
		for (text in fileTextGroups[i])
			text.color = textColor;
	}

	optionsText.color = (curRow == 1 && curBottomIndex == 0) ? SELECTED_COLOR : UNSELECTED_COLOR;
	creditsText.color = (curRow == 1 && curBottomIndex == 1) ? SELECTED_COLOR : UNSELECTED_COLOR;

	var targetX:Float;
	var targetY:Float;

	if (curRow == 0) {
		var box:FunkinSprite = fileBoxes[curFileIndex];
		targetX = box.x + 30;
		targetY = box.y + box.height / 2 - heart.height / 2;
	} else {
		var text:FunkinText = (curBottomIndex == 0) ? optionsText : creditsText;
		targetX = text.x - 35;
		targetY = text.y + text.height / 2 - heart.height / 2;
	}

	FlxTween.cancelTweensOf(heart);
	if (instant)
		heart.setPosition(targetX, targetY);
	else
		FlxTween.tween(heart, {x: targetX, y: targetY}, 0.08, {ease: FlxEase.quadOut});
}
