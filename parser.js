(function() {
  var KITCO_URL, Parser, fs, jquery, jsdom;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  require.paths.unshift("./node_modules");
  jsdom = require("jsdom");
  fs = require("fs");
  jquery = fs.readFileSync("./jquery-1.6.4.min.js").toString();
  KITCO_URL = "http://www.kitco.com/market";
  Parser = (function() {
    function Parser() {
      this.gold = {
        bid: 0,
        ask: 0
      };
      this.silver = {
        bid: 0,
        ask: 0
      };
    }
    Parser.prototype.parse = function() {
      console.log("Requesting " + KITCO_URL);
      return jsdom.env({
        html: KITCO_URL,
        src: [jquery],
        done: __bind(function(errors, window) {
          if (errors != null) {
            return console.log(errors);
          } else {
            return this.findSpotPrice(window);
          }
        }, this)
      });
    };
    Parser.prototype.findSpotPrice = function(window) {
      var $;
      $ = window.$;
      return $("p").each(__bind(function(index, elem) {
        var tbody, tdAsk, tdBid, tr;
        if ($(elem).text().toLowerCase().indexOf("the world spot price") !== -1) {
          tbody = $(elem).parent().parent().parent();
          tr = tbody.find("tr:nth-child(4)");
          tdBid = tr.find("td:nth-child(5)");
          tdAsk = tr.find("td:nth-child(6)");
          this.gold.bid = tdBid.text();
          this.gold.ask = tdAsk.text();
          tr = tbody.find("tr:nth-child(5)");
          tdBid = tr.find("td:nth-child(5)");
          tdAsk = tr.find("td:nth-child(6)");
          this.silver.bid = tdBid.text();
          this.silver.ask = tdAsk.text();
          console.log(this.gold);
          console.log(this.silver);
          return false;
        }
      }, this));
    };
    Parser.prototype.goldPrice = function() {
      return this.gold;
    };
    Parser.prototype.silverPrice = function() {
      return this.silver;
    };
    return Parser;
  })();
  exports.getParserInstance = function() {
    return new Parser();
  };
}).call(this);
