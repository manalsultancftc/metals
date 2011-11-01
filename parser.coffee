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
				@gold.bid = Number tdBid.text()
				@gold.ask = Number tdAsk.text()

				#get silver price
				tr = tbody.find("tr:nth-child(5)")
				tdBid = tr.find("td:nth-child(5)")
				tdAsk = tr.find("td:nth-child(6)")
				@silver.bid = Number tdBid.text()
				@silver.ask = Number tdAsk.text()

				console.log @gold
				console.log @silver
				
				no #stop each loop

	goldPrice: ->
		#post: returns latest gold prices parsed from kitco.com/market
		@gold.bidPerKg = TROY_OZ_PER_KILO * @gold.bid
		@gold.askPerKg = TROY_OZ_PER_KILO * @gold.ask
		@gold

	silverPrice: ->
		#post: returns latest silver prices parsed from kitco.com/market
		@silver.bidPerKg = TROY_OZ_PER_KILO * @silver.bid
		@silver.askPerKg = TROY_OZ_PER_KILO * @silver.ask
		@silver

exports.getParserInstance = ->
	new Parser()
