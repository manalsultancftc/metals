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
jquery 	= fs.readFileSync("./jquery-1.7.min.js").toString()

#defines
KITCO_URL 			= "http://www.kitco.com/market"
BULLIONVAULT_URL 	= "http://www.bullionvault.com"
CASEY_URL 			= "http://www.caseyresearch.com"
TROY_OZ_PER_KILO 	= 32.1507466

class Parser
	constructor: ->
		@metals =
			gold:
				quote: 0
				quoteKg: 0

			silver:
				quote: 0
				quoteKg: 0

			platinum:
				quote: 0
				quoteKg: 0

			palladium:
				quote: 0
				quoteKg: 0
	
	parse: ->
		console.log "Requesting #{CASEY_URL}"
		jsdom.env
			html: CASEY_URL
			src: [
				jquery
			]
			done: (errors, window) =>
				if errors?
					console.log errors
				else
					@findSpotPrice window

	normalizePrice: (price) ->
		#pre: price is a dollar price e.g $1,680.20
		#post: returns normalized price as number
		price = price[1..price.length] 	#remove currency symbol $
		price = price.replace ",", "" 	#remove commas
		Number price

	findSpotPrice: (window) ->
		$ = window.$ #local jquery for page

		#get precious metals price from casey frontpage
		gold = $("td.casey-charts.column-0").first()
		silver = $("td.casey-charts.column-1").first()
		platinum = $("td.casey-charts.column-2").first()
		palladium = $("td.casey-charts.column-3").first()

		#convert to numbers
		gold = @normalizePrice gold.html()
		silver = @normalizePrice silver.html()
		platinum = @normalizePrice platinum.html()
		palladium = @normalizePrice palladium.html()

		#set json
		@metals.gold.quote = gold
		@metals.gold.quoteKg = Math.round(gold * TROY_OZ_PER_KILO * 100) / 100
		@metals.silver.quote = silver
		@metals.silver.quoteKg = Math.round(silver * TROY_OZ_PER_KILO * 100) / 100
		@metals.platinum.quote = platinum
		@metals.platinum.quoteKg = Math.round(platinum * TROY_OZ_PER_KILO * 100) / 100
		@metals.palladium.quote = palladium
		@metals.palladium.quoteKg = Math.round(palladium * TROY_OZ_PER_KILO * 100) / 100

		console.log @metals

	prices: ->
		#post: returns latest precious metals prices 
		# 		parsed from kitco.com/market
		@metals

exports.getParserInstance = ->
	new Parser()
