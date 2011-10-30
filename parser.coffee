fs = require "fs"  		#read local files

require.paths.unshift "./node_modules"

#libraries
jsdom 	= require "jsdom" 		#CommonJS DOM
jquery 	= fs.readFileSync("./jquery-1.6.4.min.js").toString()

#defines
KITCO_URL = "http://www.kitco.com/market"

class Parser
	constructor: ->
		@gold =
			bid: 0
			ask: 0

		@silver =
			bid: 0
			ask: 0
	
	parse: ->
		console.log "Requesting #{KITCO_URL}"
		jsdom.env
			html: KITCO_URL
			src: [
				jquery
			]
			done: (errors, window) =>
				if errors?
					console.log errors
				else
					@findSpotPrice window

	findSpotPrice: (window) ->
		$ = window.$ #local jquery for page

		#each p
		$("p").each (index, elem) =>
			if $(elem).text().toLowerCase().indexOf("the world spot price") isnt -1
				#found correct paragraph for world spot prices
				#get tbody
				tbody = $(elem).parent().parent().parent()

				#get gold price
				tr = tbody.find("tr:nth-child(4)")
				tdBid = tr.find("td:nth-child(5)")
				tdAsk = tr.find("td:nth-child(6)")
				@gold.bid = tdBid.text()
				@gold.ask = tdAsk.text()

				#get silver price
				tr = tbody.find("tr:nth-child(5)")
				tdBid = tr.find("td:nth-child(5)")
				tdAsk = tr.find("td:nth-child(6)")
				@silver.bid = tdBid.text()
				@silver.ask = tdAsk.text()

				console.log @gold
				console.log @silver
				
				no #stop each loop

	goldPrice: ->
		#post: returns latest gold prices parsed from kitco.com/market
		@gold

	silverPrice: ->
		#post: returns latest silver prices parsed from kitco.com/market
		@silver

exports.getParserInstance = ->
	new Parser()
