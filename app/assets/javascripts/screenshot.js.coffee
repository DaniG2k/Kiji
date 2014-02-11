page = require('webpage').create()
if phantom.args.length < 1
  console.log "Usage: phantomjs screenshots.js.coffee url1 url2 url3 ..."
  phantom.exit()
else
  page.viewportSize =
    width: 1024
    height: 760

  urls = phantom.args
  for url in urls
    console.log("Processing url: #{url}")
    output = // TODO
    page.open url, (status) ->
    if status isnt "success"
      console.log "Unable to load the address: #{url}"
      phantom.exit()
    else
      window.setTimeout (->
          page.clipRect =
            top: 0
            left: 0
            width: 1024
            height: 760
            
          page.render output
      ), 200
  console.log "Exiting"
  phantom.exit()
