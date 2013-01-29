@Scarlet = Scarlet = {}

class Scarlet.Test
  #
  # Options
  #

  # The url of the site being tested
  targetUrl: null

  # The function to call with the results
  callback: ->

  # Maximum cache speed variance for a request to be considered cached
  cacheThreshold: 0.2

  #
  # State
  #

  # The response time in milliseconds that it takes to load a cached favicon
  cacheLatency: null

  # The response time in milliseconds that it took to load the target favicon
  # with a cold cache
  targetColdLatency: null

  # The response time in milliseconds that it took to load the target favicon
  # with a warm cache
  targeWarmLatency: null

  #
  # Methods
  #

  constructor: (targetUrl, callback) ->
    @targetUrl = targetUrl
    @callback = callback

  run: =>
    @measureCache((cacheLatency) =>
      @cacheLatency = cacheLatency

      @compareDomains()
    )

    @measureTarget((targetColdLatency) =>
      @targetColdLatency = targetColdLatency

      @compareDomains()
    )

  compareDomains: =>
    if @cacheLatency? && @targetColdLatency?
      console.log @targetColdLatency
      if @cacheLatency / @targetColdLatency >= @cacheThreshold
        @callback(true)
      else
        @callback(false)

  # Measure the cached response time of the origin server's favicon
  measureCache: (callback) =>
    callback(5)
    return
    @measure(window.location.origin, =>
      @measure(window.location.origin, callback)
    )

  measureTarget: (callback) =>
    @measure(@targetUrl, callback)

  measure: (domain, callback) =>
    startTime = new Date()
    img = document.createElement("img")
    img.onload = -> callback(new Date() - startTime)
    img.src = "#{domain}favicon.ico"
