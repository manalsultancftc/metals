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

#libraries we depend on
redis = require "redis" 	#redis datastore
express = require "express" #express http server

class Golddigger
	constructor: ->
		console.log "init golddigger #{VERSION}"

		@app = express.createServer()
		@app.listen 8001
		@setRoutes()

	setRoutes: ->
		@app.get "/", (req, res) ->
			res.send "welcome to golddigger #{VERSION}"

new Golddigger()
