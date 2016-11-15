function analyze(json) {
  var name = prompt('What would you like to call this project?');
  if (!name) {
    name = json.info.author + ' (' + json.info.projectID + ')';
  }
  var allScripts = json.scripts || [];
  allScripts.push(json.children.map(function jsonChildScriptMap(op) {
    return typeof op.scripts == 'undefined' ? [] : op.scripts;
  }));
  var data = countBlocks(allScripts);
  var html = '<div class="project"><h2>' + name + '</h2><div class="bar">';
  var total = 0;
  for (var cat in data.counts) {
    total += data.counts[cat];
  }
  var percentLeft = 100;
  for (var i = blockOrder.length; i--;) {
    var cat = blockOrder[i];
    var width = i === 0 ? percentLeft : Math.round(data.counts[cat]*100/total);
    var border = Math.round(data.unique[cat]*100/BLOCKS[cat].length);
    if (typeof data.counts[cat] == 'undefined') {
      width = 0;
      border = 0;
    }
    percentLeft -= width;
    html += '<div class="section ' + cat + '" style="width:' + width + '%;border-bottom-width:' + border + 'px">&nbsp;</div>';
  }
  document.getElementById('list').innerHTML += html + '</div></div>';
}
