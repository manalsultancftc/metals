###

golddigger

@author Giovanni Martina
@date 20-10-2011
Copyright 2011

node.js server that does the following:
- 	periodically GETs http://www.kitco.com/market/ to get the current World Gold Spot Price
 	and save the latest Spot Price to a redis instance
- 	has an API so callers can request the latest Gold Spot Price

###

#defines
VERSION = "0.1"
POLL_WAIT = 10000

#libraries we depend on
require "coffee-script" 		#we wanna code libs in CoffeeScript
redis = require "redis" 		#redis datastore
express = require "express" 	#express http server
parsing = require "./parser" 	#kitco.com html parser

class Golddigger
	constructor: ->
		console.log "Welcome to golddigger #{VERSION}!"
		@setup()

	setup: ->
		#create express server
		@app = express.createServer()
		@app.listen 8001

		#set express routes
		@setRoutes()

		#create parser
		@parser = parsing.getParserInstance()
		@parser.start()

		#start polling kitco for precious metal data
		setInterval =>
			@poll()
		, POLL_WAIT

	setRoutes: ->
		@app.get "/", (req, res) ->
			res.send "welcome to golddigger #{VERSION}"

	poll: ->
		console.log "should poll kitco"

new Golddigger()
