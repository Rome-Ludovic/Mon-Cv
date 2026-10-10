import flixel.group.FlxSpriteGroup;
import funkin.menus.ui.Alphabet;
import flixel.text.FlxTextBorderStyle;
import funkin.savedata.FunkinSave;
import Modifiers;

var alphs:FlxSpriteGroup = new FlxSpriteGroup();
var plates:FlxSpriteGroup = new FlxSpriteGroup();
var checks:FlxSpriteGroup = new FlxSpriteGroup();
var valueTexts:FlxSpriteGroup = new FlxSpriteGroup();
var upArrow:FlxSprite;
var downArrow:FlxSprite;
var leftArrow:FlxSprite;
var rightArrow:FlxSprite;


var boolOps:Array<String> = ["Sick Only", "Practice Mode", "Instakill on Miss", "Botplay", "Endless Mode"];
var stringOps:Array<String> = []; // dunno why but this keeps it from breaking
var numericOps:Array<String> = ["Playback Rate", "Scroll Speed Mult.", "Health Gain Mult.", "Health Loss Mult."];
var actionOps:Array<String> = ["Close Menu"];


var opts:Array<String> =
[
// Boolean modifiers
"Sick Only",
"Practice Mode",
"Instakill on Miss",
"Botplay",
"Endless Mode",
// Numeric modifiers
"Playback Rate",
"Scroll Speed Mult.",
"Health Gain Mult.",
"Health Loss Mult.",
// Close menu
"Close Menu"
];


var maxVisible:Int = 4;
var rowHeight:Float = 92;
var startY:Float = 285;
var listX:Float = 465;
var scrollIndex:Int = 0;

// plate sizing
var plateOffsetX:Float = -70;
var plateWidth:Float = 450;
var plateHeight:Float = 85;

// Close plate sizing
var exitPlateWidth:Float = 290;
var exitPlateHeight:Float = 74;

// checkbox sizing
var checkSize:Float = 10;
var checkPadLeft:Float = 25;
var textPadFromCheck:Float = 75;

// text value
var valueFieldWidth:Float = 150;
var valuePadRight:Float = 46;

// arrow bounce tween (oopsie I messed up the left and right arrow, they're reversed but I don't feel like fixing it)
var arrowBounceAmount:Float = 4;
var arrowBounceTime:Float = 0.04;

var curOpt = 0;
var bg:FlxSprite;

function isExitOpt(opt:String):Bool {
    return opt == "Close Menu";
}

function isNumericOpt(opt:String):Bool {
    return opt == "Playback Rate" 
        || opt == "Scroll Speed Mult." 
        || opt == "Health Gain Mult." 
        || opt == "Health Loss Mult.";
} // idk how to put the array directly so it's kinda hardcoded sorry

function create(){
    loadSavedModifiers();

    CoolUtil.playMusic(Paths.music("modifiers"), 0);
    FlxTween.tween(FlxG.sound.music, {volume: 0.7}, 0.5);

    bg = new FlxSprite().loadGraphic(Paths.image("modifiers/bg"));
    bg.alpha = 0;
    bg.setPosition(FlxG.width / 2 - bg.width / 2, FlxG.height / 2 - bg.height / 2 + 7);

    add(bg);

    for(opt in opts){
        var isExit = isExitOpt(opt);

        // Plate for the modifier row.
        // "Close Menu" uses Plate_Exit
        var plate:FlxSprite = new FlxSprite();
        if(isExit){
            plate.frames = Paths.getSparrowAtlas("modifiers/Plate_Exit");
            plate.animation.addByPrefix("unselected", "Plate_Unselected", 0, false);
            plate.animation.addByPrefix("selected", "Plate_Selected", 0, false);
        } 
        else{
            plate.frames = Paths.getSparrowAtlas("modifiers/Plate");
            plate.animation.addByPrefix("unselected", "plate_Unselected", 0, false);
            plate.animation.addByPrefix("selected", "plate_Selected", 0, false);
        }
        plates.add(plate);
        setPlateFrame(plate, false, isExit ? exitPlateWidth : plateWidth, isExit ? exitPlateHeight : plateHeight);

        // Text for the modifier
        var alph:FlxText = new FlxText(0, 0, 0, opt, 20);
        alph.setFormat(Paths.font("Lithos Black Regular.otf"), 20, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
        alphs.add(alph);

        // Checkbox
        var check:FlxSprite = new FlxSprite();
        checks.add(check);
        setCheckGraphic(check, checkKeyFor(opt));
        check.visible = hasCheckIcon(opt);

        var vt:FlxText = new FlxText(0, 0, 0, "", 22);
        vt.setFormat(Paths.font("Lithos Black Regular.otf"), 22, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
        valueTexts.add(vt);
    }

    add(plates);
    add(alphs);
    add(checks);
    add(valueTexts);

    updateValueTexts();
    repositionAll();
    updateColors();

    bg.alpha = 0;
    plates.alpha = alphs.alpha = checks.alpha = valueTexts.alpha = 0;
    FlxTween.tween(plates, {alpha: 1}, 0.2);
    FlxTween.tween(alphs, {alpha: 1}, 0.2, {onComplete: updateColors});
    FlxTween.tween(checks, {alpha: 1}, 0.2);
    FlxTween.tween(valueTexts, {alpha: 1}, 0.2);
    FlxTween.tween(bg, {alpha: 1}, 0.2);
}

function update(elapsed:Float){
    if(FlxG.keys.justPressed.ENTER) toggle();
    if(FlxG.keys.justPressed.ESCAPE) closeMenu();
    if(FlxG.keys.justPressed.UP || FlxG.mouse.wheel == 1) chng(-1);
    else if(FlxG.keys.justPressed.DOWN || FlxG.mouse.wheel == -1) chng(1);

    var opt = opts[curOpt];

    if(numericOps.contains(opt)){
        if(FlxG.keys.justPressed.LEFT) adjustNumeric(opt, -1);
        if(FlxG.keys.justPressed.RIGHT) adjustNumeric(opt, 1);
    }
}

function chng(c:Int){
    FlxG.sound.play(Paths.sound("menu/scroll"));
    curOpt = FlxMath.wrap(curOpt + c, 0, opts.length - 1);
    repositionAll();
    updateAlphas();
    flashArrow(c < 0 ? upArrow : downArrow);
}

function closeMenu(){
    FlxG.sound.play(Paths.sound("menu/cancel"));
    saveModifiers();
    FlxTween.tween(FlxG.sound.music, {volume: 0.7}, 0.2);
    FlxTween.tween(plates, {alpha: 0}, 0.2);
    FlxTween.tween(alphs, {alpha: 0}, 0.2);
    FlxTween.tween(checks, {alpha: 0}, 0.2);
    FlxTween.tween(valueTexts, {alpha: 0}, 0.2);
    FlxTween.tween(bg, {alpha: 0}, 0.2, {onComplete: function(){
        CoolUtil.playMusic(Paths.music("freakyMenu"), 0);
        close();
    }});
}

function toggle(){
    var opt = opts[curOpt];

    if(opt == "Close Menu"){
        closeMenu();
        return;
    }

    if(numericOps.contains(opt) || stringOps.contains(opt)) return;

    FlxG.sound.play(Paths.sound("menu/confirm"));
    setValue(opt, !getValue(opt));
    updateColors();
}


function repositionAll(){
    var maxStart = Std.int(Math.max(0, opts.length - maxVisible));
    scrollIndex = Std.int(Math.min(maxStart, Math.max(0, curOpt - Std.int(maxVisible / 2))));

    var plateX = listX + plateOffsetX;
    var checkX = plateX + checkPadLeft;
    var textX = checkX + checkSize + textPadFromCheck;
    var valueX = plateX + plateWidth - valueFieldWidth - valuePadRight;
    var boardCenterX = plateX + plateWidth / 2;

    for(i in 0...opts.length){
        var plate = plates.members[i];
        var alph = alphs.members[i];
        var check = checks.members[i];
        var vt = valueTexts.members[i];
        var opt = opts[i];
        var isExit = isExitOpt(opt);
        var visible = (i >= scrollIndex && i < scrollIndex + maxVisible);

        plate.visible = visible;
        alph.visible = visible;
        check.visible = visible && hasCheckIcon(opt);
        vt.visible = visible && (numericOps.contains(opt) || stringOps.contains(opt));

        if(visible){
            var row = i - scrollIndex;
            var y = startY + (rowHeight * row);
            var isNumeric = isNumericOpt(opt);

            if(isExit){
                plate.x = boardCenterX - plate.width / 2;
                plate.y = y - ((exitPlateHeight - alph.height) / 2);
                
                alph.setFormat(Paths.font("Lithos Black Regular.otf"), 24, 0xFFFFFFFF, "left", FlxTextBorderStyle.OUTLINE, 0xFF000000);
                alph.x = plate.x + ((plate.width - alph.width) / 2 - 5);
                alph.y = y - 2.5;
            } else {
                plate.x = plateX;
                plate.y = y - ((plateHeight - alph.height) / 2);

                check.x = checkX;
                check.y = y + ((alph.height - checkSize) / 2 - 25);
                
                if(isNumeric){alph.x = textX - 80;} 
                else{alph.x = textX;}
                alph.y = y + 2.5;

                var valueCenterX = valueX + 80;
                vt.x = valueCenterX - (vt.width / 2);
                vt.y = y;
            }
        }
    }

    if(upArrow == null){
        upArrow = makeArrow("Arrow");
        upArrow.setGraphicSize(90, 0);
        upArrow.updateHitbox();
        upArrow.angle = 180;
        add(upArrow);

        downArrow = makeArrow("Arrow");
        downArrow.setGraphicSize(90, 0);
        downArrow.updateHitbox();
        add(downArrow);

        leftArrow = makeArrow("Scroll");
        leftArrow.setGraphicSize(40, 0);
        leftArrow.updateHitbox();
        leftArrow.angle = -90;
        add(leftArrow);

        rightArrow = makeArrow("Scroll");
        rightArrow.setGraphicSize(40, 0);
        rightArrow.updateHitbox();
        rightArrow.angle = 90;
        add(rightArrow);
    }

    var arrowCenterX = boardCenterX;
    upArrow.x = arrowCenterX - upArrow.width / 2;
    upArrow.y = startY - 92;

    downArrow.x = arrowCenterX - downArrow.width / 2;
    downArrow.y = startY + (rowHeight * maxVisible) - 32;

    upArrow.visible = scrollIndex > 0;
    downArrow.visible = (scrollIndex + maxVisible) < opts.length;

    var curOptName = opts[curOpt];
    var showValueArrows = numericOps.contains(curOptName) && (curOpt >= scrollIndex && curOpt < scrollIndex + maxVisible);
    leftArrow.visible = showValueArrows;
    rightArrow.visible = showValueArrows;
    if(showValueArrows){
        var curVt = valueTexts.members[curOpt];

        leftArrow.x = leftArrow.width + 722;
        leftArrow.y = curVt.y + ((curVt.height - leftArrow.height) / 2);
        rightArrow.x = rightArrow.width + 618;
        rightArrow.y = leftArrow.y;
    }
}

function makeArrow(key:String):FlxSprite {
    var a = new FlxSprite();
    a.frames = Paths.getSparrowAtlas("modifiers/" + key);
    a.animation.addByPrefix("blue", "arrow_Glue", 0, false);
    a.animation.addByPrefix("orange", "arrow_Jaorange", 0, false);
    a.animation.play("blue");
    return a;
}

function flashArrow(arrow:FlxSprite){
    if(arrow == null) return;
    arrow.animation.play("orange");
    new FlxTimer().start(0.15, function(_){
        arrow.animation.play("blue");
    });
    bounceArrow(arrow);
}

function bounceArrow(arrow:FlxSprite){
    FlxTween.cancelTweensOf(arrow);

    if(arrow == upArrow || arrow == downArrow){
        var baseY = arrow.y;
        var dir = (arrow == upArrow) ? -1 : 1;
        arrow.y = baseY;
        FlxTween.tween(arrow, {y: baseY + (arrowBounceAmount * dir)}, arrowBounceTime, {
            ease: FlxEase.quadOut,
            onComplete: function(_){
                FlxTween.tween(arrow, {y: baseY}, arrowBounceTime, {ease: FlxEase.quadIn});
            }
        });
    } else if(arrow == leftArrow || arrow == rightArrow){
        var baseX = arrow.x;
        var dir = (arrow == rightArrow) ? -1 : 1;
        arrow.x = baseX;
        FlxTween.tween(arrow, {x: baseX + (arrowBounceAmount * dir)}, arrowBounceTime, {
            ease: FlxEase.quadOut,
            onComplete: function(_){
                FlxTween.tween(arrow, {x: baseX}, arrowBounceTime, {ease: FlxEase.quadIn});
            }
        });
    }
}


function getNumericConfig(name:String):Dynamic {
    return switch(name){
        case "Playback Rate": {min: 0.5, max: 3, step: 0.05, decimals: 2};
        case "Scroll Speed Mult.": {min: 0.5, max: 3, step: 0.05, decimals: 2};
        case "Health Gain Mult.": {min: 0, max: 5, step: 0.05, decimals: 2};
        case "Health Loss Mult.": {min: 0.5, max: 5, step: 0.05, decimals: 2};
        default: {min: 0, max: 1, step: 0.05, decimals: 2};
    }
}

function adjustNumeric(name:String, dir:Int){
    var cfg = getNumericConfig(name);
    var current:Float = getValue(name);
    var next:Float = current + (cfg.step * dir);
    if(next < cfg.min) next = cfg.min;
    if(next > cfg.max) next = cfg.max;
    next = FlxMath.roundDecimal(next, cfg.decimals);
    if(next != current){
        setValue(name, next);
        FlxG.sound.play(Paths.sound("menu/scroll"));
        updateValueTexts();
        repositionAll(); // re-center the (now different-width) value text and the arrows around it
    }
    flashArrow(dir < 0 ? rightArrow : leftArrow);
}

function getValue(name:String):Dynamic {
    return switch(name){
        case "Sick Only": Modifiers.sickOnly;
        case "Practice Mode": Modifiers.practiceMode;
        case "Instakill on Miss": Modifiers.instakillMiss;
        case "Botplay": Modifiers.botplayMode;
        case "Endless Mode": Modifiers.endlessMode;
        case "Playback Rate": Modifiers.playbackRate;
        case "Scroll Speed Mult.": Modifiers.scrollSpeedMult;
        case "Health Gain Mult.": Modifiers.healthGainMult;
        case "Health Loss Mult.": Modifiers.healthLossMult;
        default: null;
    }
}

function setValue(name:String, value:Dynamic){
    switch(name){
        case "Sick Only": Modifiers.sickOnly = value;
        case "Practice Mode": Modifiers.practiceMode = value;
        case "Instakill on Miss": Modifiers.instakillMiss = value;
        case "Botplay": Modifiers.botplayMode = value;
        case "Endless Mode": Modifiers.endlessMode = value;
        case "Playback Rate": Modifiers.playbackRate = value;
        case "Scroll Speed Mult.": Modifiers.scrollSpeedMult = value;
        case "Health Gain Mult.": Modifiers.healthGainMult = value;
        case "Health Loss Mult.": Modifiers.healthLossMult = value;
    }
}

function fieldKey(name:String):String {
    return switch(name){
        case "Sick Only": "sickOnly";
        case "Practice Mode": "practiceMode";
        case "Instakill on Miss": "instakillMiss";
        case "Botplay": "botplayMode";
        case "Endless Mode": "endlessMode";
        case "Playback Rate": "playbackRate";
        case "Scroll Speed Mult.": "scrollSpeedMult";
        case "Health Gain Mult.": "healthGainMult";
        case "Health Loss Mult.": "healthLossMult";
        default: null;
    }
}

function loadSavedModifiers(){
    var saved:Dynamic = FunkinSave.save.data.modifiersData;
    if(saved == null) return;
    for(name in opts){
        if(actionOps.contains(name)) continue;
        var key = fieldKey(name);
        if(Reflect.hasField(saved, key))
            setValue(name, Reflect.field(saved, key));
    }
}

function saveModifiers(){
    var data:Dynamic = {};
    for(name in opts){
        if(actionOps.contains(name)) continue;
        Reflect.setField(data, fieldKey(name), getValue(name));
    }
    FunkinSave.save.data.modifiersData = data;
    FunkinSave.save.flush();
}

function hasCheckIcon(opt:String):Bool {
    return boolOps.contains(opt);
}

function checkKeyFor(opt:String):String {
    if(boolOps.contains(opt)) return (getValue(opt) == true) ? "check2" : "check1";
    return null;
}

function setCheckGraphic(check:FlxSprite, key:String){
    if(key == null) return;
    check.loadGraphic(Paths.image("modifiers/" + key));
    check.updateHitbox();
}

function setPlateFrame(plate:FlxSprite, selected:Bool, w:Float, h:Float){
    plate.animation.play(selected ? "selected" : "unselected");
    plate.setGraphicSize(Std.int(w), Std.int(h));
    plate.updateHitbox();
}

function updateColors(){
    for(i in 0...opts.length){
        var opt = opts[i];
        if(hasCheckIcon(opt))
            setCheckGraphic(checks.members[i], checkKeyFor(opt));
    }
    updateAlphas();
}

function updateValueTexts(){
    for(i in 0...opts.length){
        var opt = opts[i];
        var vt = valueTexts.members[i];
        if(numericOps.contains(opt))
            vt.text = getValue(opt) + "X";
        else if(stringOps.contains(opt))
            vt.text = Std.string(getValue(opt));
    }
}

function updateAlphas(){
    for(i in 0...opts.length){
        var plate = plates.members[i];
        var opt = opts[i];
        var isExit = isExitOpt(opt);
        var selected = (curOpt == i);

        setPlateFrame(plate, selected, isExit ? exitPlateWidth : plateWidth, isExit ? exitPlateHeight : plateHeight);
        plate.alpha = selected ? 1 : 0.85;

        alphs.members[i].alpha = selected ? 1 : 0.6;
        checks.members[i].alpha = selected ? 1 : 0.6;
        valueTexts.members[i].alpha = selected ? 1 : 0.6;
    }
}