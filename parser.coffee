###

metals

@author Giovanni Martina
@date 1-11-2011
Copyright 2011

kitco.com/market parser

###

#libraries we depend on
fs 		= require "fs"  		#read local files
jsdom 	= require "jsdom" 		#CommonJS DOM
jquery 	= fs.readFileSync("./jquery-1.6.4.min.js").toString()

#defines
KITCO_URL 			= "http://www.kitco.com/market"
TROY_OZ_PER_KILO 	= 32.1507466

class Parser
	constructor: ->
		@metals =
			gold:
				bid: 0
				ask: 0

			silver:
				bid: 0
				ask: 0

			platinum:
				bid: 0
				ask: 0

			palladium:
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
				@metals.gold.bid = Number tdBid.text()
				@metals.gold.ask = Number tdAsk.text()
				@metals.gold.bidPerKg = TROY_OZ_PER_KILO * @metals.gold.bid
				@metals.gold.askPerKg = TROY_OZ_PER_KILO * @metals.gold.ask

				#get silver price
				tr = tbody.find("tr:nth-child(5)")
				tdBid = tr.find("td:nth-child(5)")
				tdAsk = tr.find("td:nth-child(6)")
				@metals.silver.bid = Number tdBid.text()
				@metals.silver.ask = Number tdAsk.text()
				@metals.silver.bidPerKg = TROY_OZ_PER_KILO * @metals.silver.bid
				@metals.silver.askPerKg = TROY_OZ_PER_KILO * @metals.silver.ask

				#get platinum price
				tr = tbody.find("tr:nth-child(6)")
				tdBid = tr.find("td:nth-child(5)")
				tdAsk = tr.find("td:nth-child(6)")
				@metals.platinum.bid = Number tdBid.text()
				@metals.platinum.ask = Number tdAsk.text()
				@metals.platinum.bidPerKg = TROY_OZ_PER_KILO * @metals.platinum.bid
				@metals.platinum.askPerKg = TROY_OZ_PER_KILO * @metals.platinum.ask

				#get palladium price
				tr = tbody.find("tr:nth-child(7)")
				tdBid = tr.find("td:nth-child(5)")
				tdAsk = tr.find("td:nth-child(6)")
				@metals.palladium.bid = Number tdBid.text()
				@metals.palladium.ask = Number tdAsk.text()
				@metals.palladium.bidPerKg = TROY_OZ_PER_KILO * @metals.palladium.bid
				@metals.palladium.askPerKg = TROY_OZ_PER_KILO * @metals.palladium.ask

				console.log @metals
				
				no #stop each loop

	prices: ->
		#post: returns latest precious metals prices 
		# 		parsed from kitco.com/market
		@metals

exports.getParserInstance = ->
	new Parser()
