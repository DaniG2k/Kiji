if phantom.args.length < 1
  console.log "Usage: phantomjs screenshots.js.coffee url1 url2 url3 ..."
  phantom.exit()
else
  page = require('webpage').create()
  
  page.onResourceError = (resourceError) ->
    page.reason = resourceError.errorString
    page.reason_url = resourceError.url
  
  page.viewportSize =
    width: 1024
    height: 760

  urls = phantom.args
  i = 1
  for url in urls
    do (url) ->
      console.log "Processing url: #{url}"
      output = "screenshot-#{i}.png"
      console.log "Output file: #{output}"
      page.open url, (status) ->
        if status isnt 'success'
          console.log "Error opening url \"#{page.reason_url}\": #{page.reason}"
          phantom.exit(1)
        else
          console.log "Page opened.."
          window.setTimeout (->
            page.clipRect =
              top: 0
              left: 0
              width: 1024
              height: 760
            console.log "Rendering image"
            page.render(output)
          ), 200

          console.log "Image #{i} processed"

      i += 1

  console.log "Exiting"
  phantom.exit()
