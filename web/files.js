function addProjectByUrl() {
  var url = document.getElementById('url').value;
  if (!url.match('scratch.mit.edu')) {
    console.error('Invalid URL');
    return false;
  }
  console.log('fetching project', urlToStaticJson(url));
  var jsonRequest = new Request(urlToStaticJson(url));
  fetch(jsonRequest).then(function(response) {
    console.log(' - loaded');
    return response.json().then(analyze);
  });
}
// https://scratch.mit.edu/projects/124586203/
// https://scratch.mit.edu/projects/124636317/#editor
function urlToStaticJson(url) {
  var idRegex = /projects\/([^\/]+)\//;
  var id = idRegex.exec(url)[1];
  return 'https://cdn.projects.scratch.mit.edu/internalapi/project/' + id + '/get/scrape';
}

function getEntries(file, onend) {
  zip.workerScriptsPath = './vendor/zip/';
  zip.createReader(new zip.BlobReader(file), function(zipReader) {
    zipReader.getEntries(onend);
  }, onerror);
}
function fileInputChange(fileInput) {
  fileInput.disabled = true;
  getEntries(fileInput.files[0], function unzip(entries) {
    for (var i = 0; i < entries.length; i++) {
      if (entries[i].filename == 'project.json') {
        var writer = new zip.TextWriter();
        entries[i].getData(writer, function unzipCollect(file) { analyze(JSON.parse(file)); } );
        break;
      }
    }
  });
}
