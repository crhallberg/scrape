function sort(button) {
  var type = button.className.substring('sort-btn '.length);
  var projects = Array.prototype.slice.call(document.querySelectorAll('.project'));
  for (var i = 0; i < projects.length; i++) {
    var sections = projects[i].querySelectorAll('.section');
    for (var j = 0; j < sections.length; j++) {
      if (sections[j].className.indexOf(type) > -1) {
        sections[j].style.float = 'left';
      } else {
        sections[j].style.float = 'right';
      }
    }
  }
  projects = projects.sort(function(a, b) {
    // console.log(a.querySelector('.section.' + type).style.width);
    return parseInt(b.querySelector('.section.' + type).style.width) - parseInt(a.querySelector('.section.' + type).style.width);
  });
  var list = document.getElementById('list');
  list.innerHTML = '';
  for (var i = 0; i < projects.length; i++) {
    list.appendChild(projects[i]);
  }
}

function addButtons() {
  var buttons = document.getElementById('buttons');
  for (var i=0; i < blockOrder.length; i++) {
    buttons.innerHTML += '<a class="sort-btn ' + blockOrder[i] + '" onClick="sort(this)">' + blockOrder[i] + '</a>';
  }
}
