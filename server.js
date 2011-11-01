(function() {
  /*
  
  golddigger
  
  @author Giovanni Martina
  @date 20-10-2011
  Copyright 2011
  
  node.js server that does the following:
  - 	periodically GETs http://www.kitco.com/market/ to get the current World Gold Spot Price
   	and save the latest Spot Price to a redis instance
  - 	has an API so callers can request the latest Gold Spot Price
  
  */
  var Golddigger, POLL_WAIT, VERSION;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  VERSION = "0.1";
  POLL_WAIT = 15 * 60 * 1000;
  Golddigger = (function() {
    function Golddigger() {
      var express, server, _ref, _ref2;
      require.paths.unshift("./node_modules");
      console.log(require.paths);
      this.host = (_ref = process.env.VCAP_APP_HOST) != null ? _ref : "localhost";
      this.port = (_ref2 = process.env.VCAP_APP_PORT) != null ? _ref2 : 8001;
      console.log("Welcome to golddigger " + VERSION);
      console.log("Running @ " + this.host + ":" + this.port);
      express = require("express");
      server = express.createServer();
      server.listen(this.port);
      server.get("/", function(req, res) {
        return res.send("hey there");
      });
    }
    Golddigger.prototype.setup = function() {
      setInterval(__bind(function() {
        return this.poll();
      }, this), POLL_WAIT);
      this.app = require("express").createServer();
      this.app.listen(this.port);
      return this.setRoutes();
    };
    Golddigger.prototype.setRoutes = function() {
      this.app.get("/", function(req, res) {
        return res.send("welcome to golddigger " + VERSION);
      });
      this.app.get("/gold/latest", __bind(function(req, res) {
        return res.send(this.parser.goldPrice());
      }, this));
      return this.app.get("/silver/latest", __bind(function(req, res) {
        return res.send(this.parser.silverPrice());
      }, this));
    };
    Golddigger.prototype.poll = function() {};
    return Golddigger;
  })();
  new Golddigger();
}).call(this);
