###

metals

@author Giovanni Martina
@date 20-10-2011
Copyright 2011

node.js server that does the following:
- 	periodically GETs http://www.kitco.com/market/ to get the current World Gold Spot Price
 	and save the latest Spot Price to a redis instance
- 	has an API so callers can request the latest gold and
	other precious metals spot prices

###

#libraries we depend on
redis 	= require "redis" 		#redis datastore
express = require "express" 	#express http server
parsing = require "./parser" 	#kitco.com html parser

#defines
APP_NAME 			= "metals"
VERSION 			= "0.0.1"
POLL_WAIT 			= 5*60*1000

class Metals
	constructor: ->
		@port = process.env.PORT ? 8001

		console.log "Welcome to #{APP_NAME} #{VERSION}"
		console.log "Listening on port #{@port}"

		@setup()

	setup: ->
		#create parser and perform initial parse
		@parser = parsing.getParserInstance()
		@parser.parse()

		#start polling kitco.com for precious metal market data
		setInterval =>
			@poll()
		, POLL_WAIT
		
		#create express server
		@app = express.createServer()
		@app.listen @port

		#set express routes
		@setRoutes()

	setRoutes: ->
		@app.get "/", (req, res) ->
			res.send "welcome to #{APP_NAME} #{VERSION}"

		@app.get "/metals/latest", (req, res) =>
			res.send @parser.prices()

	poll: ->
		@parser.parse()

new Metals()
