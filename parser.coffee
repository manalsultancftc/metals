request = require "request" 	#easier http request
jsdom = require "jsdom" 		#CommonJS DOM
fs = require "fs"  				#read files
jquery = fs.readFileSync("./jquery.js")

#defines
KITCO_URL = "http://www.kitco.com/market"
STATUS_OK = 200

class Parser
	start: ->
		console.log jquery
		console.log "Requesting #{KITCO_URL}"
		request
			uri: KITCO_URL, (error, response, body) =>
				if not error? and response.statusCode is STATUS_OK
					@parse body
				else
					console.log "Error trying to request: #{KITCO_URL}"
					console.log error

	parse: (html) ->
		#inject jquery into the page
		jsdom.env
			html: html
			scripts: [
				
			]

exports.getParserInstance = ->
	new Parser()
