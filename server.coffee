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



#libraries we depend on
#redis 	= require "redis" 		#redis datastore
#express = require "express" 	#express http server
#parsing = require "./parser" 	#kitco.com html parser

#defines
VERSION 			= "0.1"
POLL_WAIT 			= 15*60*1000

class Golddigger
	constructor: ->
		require.paths.unshift "./node_modules"
		console.log require.paths

		@host = process.env.VCAP_APP_HOST ? "localhost"
		@port = process.env.VCAP_APP_PORT ? 8001

		console.log "Welcome to golddigger #{VERSION}"
		console.log "Running @ #{@host}:#{@port}"

		#@setup()
		
		express = require "express"
		server = express.createServer()
		server.listen @port
		server.get "/", (req, res) ->
			res.send "hey there"

	setup: ->
		#create parser and perform initial parse
		#@parser = parsing.getParserInstance()
		#@parser.parse()

		#start polling kitco.com for precious metal market data
		setInterval =>
			@poll()
		, POLL_WAIT
		
		#create express server
		@app = require("express").createServer()
		@app.listen @port

		#set express routes
		@setRoutes()

	setRoutes: ->
		@app.get "/", (req, res) ->
			res.send "welcome to golddigger #{VERSION}"

		@app.get "/gold/latest", (req, res) =>
			res.send @parser.goldPrice()

		@app.get "/silver/latest", (req, res) =>
			res.send @parser.silverPrice()

	poll: ->
		#@parser.parse()

new Golddigger()
