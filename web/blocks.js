var blockOrder = ['motion', 'looks', 'sound', 'pen', 'vars', 'lists', 'events', 'control', 'sensing', 'operators', 'custom'];
var BLOCKS = {
  motion: ["forward:","xpos","turnRight:","ypos","turnLeft:","heading","heading:","pointTowards:","gotoX:y:","gotoSpriteOrMouse:","glideSecs:toX:y:elapsed:from:","changeXposBy:","xpos:","changeYposBy:","ypos:","bounceOffEdge","setRotationStyle"],
  looks: ["say:duration:elapsed:from:","costumeIndex","say:","sceneName","think:duration:elapsed:from:","scale","think:","show","hide","lookLike:","costume2","nextCostume","startScene","changeGraphicEffect:by:","setGraphicEffect:to:","filterReset","changeSizeBy:","setSizeTo:","comeToFront","goBackByLayers:"],
  sound: ["playSound:","doPlaySoundAndWait","stopAllSounds","playDrum","rest:elapsed:from:","noteOn:duration:elapsed:from:","instrument:","changeVolumeBy:","setVolumeTo:","volume","changeTempoBy:","setTempoTo:","tempo"],
  pen: ["clearPenTrails","stampCostume","putPenDown","putPenUp","penColor:","changePenHueBy:","setPenHueTo:","changePenShadeBy:","setPenShadeTo:","changePenSizeBy:","penSize:"],
  vars: ["setVar:to:","readVariable","changeVar:by:","showVariable:","hideVariable:"],
  lists: ["append:toList:","deleteLine:ofList:","insert:at:ofList:","lineCountOfList:","setLine:ofList:to:","getLine:ofList:","showList:","hideList:","list:contains:"],
  events: ["whenGreenFlag","whenKeyPressed","whenClicked","whenSceneStarts","broadcast:","doBroadcastAndWait","whenIReceive","whenSensorGreaterThan","whenCloned"],
  control: ["wait:elapsed:from:","doRepeat","doIf","doIfElse","doWaitUntil","doUntil","stopScripts","doForever","createCloneOf","deleteClone"],
  sensing: ["touchingColor:","color:sees:","distanceTo:","mousePressed","loudness","keyPressed:","touching:","mouseX","mouseY","soundLevel","senseVideoMotion","motion","answer","timer","timerReset","getUserName","timestamp","timeAndDate","doAsk","setVideoState","setVideoTransparency"],
  operators: ["%","&","*","+","-","/","<","=",">","randomFrom:to:","concatenate:with:","getAttribute:of:","letter:of:","stringLength:","rounded","computeFunction:of:","sqrt"],
  custom: ["procDef","call"]
};
function flatten(arr, _in) {
  var includeNumbers = _in || false;
  var ret = [];
  for (var i=0; i<arr.length; i++) {
    if (Object.prototype.toString.call(arr[i]) == "[object Array]") {
      ret = ret.concat(flatten(arr[i]));
    } else if (includeNumbers || (typeof arr[i] == 'string' && arr[i].length > 0)) {
      ret.push(arr[i]);
    }
  }
  return ret;
}

function countBlocks(scripts) {
  var blocks = flatten(scripts).sort();
  var counts = {};
  var unique = {};
  for (var i=0; i<blocks.length; i++) {
    for (var cat in BLOCKS) {
      if (BLOCKS[cat].indexOf(blocks[i]) > -1) {
        if (typeof counts[cat] == 'undefined') {
          counts[cat] = 1;
          unique[cat] = 1;
        } else {
          counts[cat] ++;
          unique[cat] ++;
        }
        while (i < blocks.length - 1 && blocks[i] == blocks[i + 1]) {
          counts[cat] ++;
          i ++;
        }
        break;
      }
    }
  }
  return {
    counts: counts,
    unique: unique
  };
}
