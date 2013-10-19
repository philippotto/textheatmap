// Generated by CoffeeScript 1.6.3
(function() {
  require.config({
    baseUrl: 'js/libs'
  });

  require(["jquery", "d3.v3", "lodash"], function() {
    var TextHeatMap, colors, getColor, i, map, testStr;
    getColor = d3.scale.category20c();
    colors = ["#fff5f0", "#fee0d2", "#fcbba1", "#fc9272", "#fb6a4a", "#ef3b2c", "#cb181d", "#a50f15", "#67000d"];
    getColor = function(i) {
      return colors[i];
    };
    TextHeatMap = (function() {
      function TextHeatMap(text) {
        this.text = text;
      }

      TextHeatMap.prototype.visualize = function() {
        this.cleanText = this.clean(this.text);
        this.analyzeText();
        return this.drawTextDIV();
      };

      TextHeatMap.prototype.clean = function(s) {
        var aWord, words;
        this.originalWords = s.split(" ");
        words = (function() {
          var _i, _len, _ref, _results;
          _ref = this.originalWords;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            aWord = _ref[_i];
            _results.push(aWord.replace(/[^a-zA-Zäöüß ]/g, "").toLowerCase());
          }
          return _results;
        }).call(this);
        return words;
      };

      TextHeatMap.prototype.cleanWord = function(s) {
        return s.replace(/[^a-zA-Zäöüß ]/g, "").toLowerCase();
      };

      TextHeatMap.prototype.analyzeText = function() {
        var maximum, word, words, _i, _len, _ref;
        words = {};
        _ref = this.cleanText;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          word = _ref[_i];
          words[word] = words[word] + 1 || 1;
        }
        maximum = _.max(words);
        this.words = words;
        return this.maximum = maximum;
      };

      TextHeatMap.prototype.drawTextSVG = function() {
        var BBox, aWord, currentLine, index, lineCount, maximum, originalWords, text, words, _i, _len, _results,
          _this = this;
        words = this.words;
        originalWords = this.originalWords;
        maximum = this.maximum;
        text = d3.select("body").append("svg").append("text").attr("x", 30).attr("y", 30).attr("word-spacing", 8);
        currentLine = text.append("tspan");
        lineCount = 1;
        _results = [];
        for (index = _i = 0, _len = originalWords.length; _i < _len; index = ++_i) {
          aWord = originalWords[index];
          BBox = currentLine[0][0].getBBox();
          if (index % 20 === 0) {
            currentLine = text.append("tspan").attr("x", 100).attr("dy", 25);
          }
          _results.push(currentLine.append("tspan").text(aWord).attr("font-family", "Lato").attr("dx", 10).style("fill", function(w, c) {
            var wordCount;
            wordCount = words[aWord];
            return getColor(Math.round(wordCount / maximum * 9 - 1));
          }).on("mouseenter", function() {
            return d3.select(this).transition(100).attr("fill-opacity", 1.0);
          }).on("mouseleave", function() {
            return d3.select(this).transition(100).attr("fill-opacity", 0.8);
          }));
        }
        return _results;
      };

      TextHeatMap.prototype.drawTextDIV = function() {
        var $heatMap, aWord, cleanedWord, colorIndex, colorString, index, span, wordCount, _i, _len, _ref, _results;
        $("body").append("<div id='HeatMapDiv' style='background: #ffffff; font-family: Lato, sans-serif; padding: 15px'></div>");
        $heatMap = $("#HeatMapDiv");
        _ref = this.originalWords;
        _results = [];
        for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
          aWord = _ref[index];
          cleanedWord = this.cleanWord(aWord);
          wordCount = this.words[cleanedWord];
          colorIndex = Math.round(wordCount / this.maximum * 9 - 1);
          colorString = getColor(colorIndex);
          span = $(document.createElement("span")).text(this.originalWords[index] + " ").css("color", colorString);
          _results.push($heatMap.append(span));
        }
        return _results;
      };

      return TextHeatMap;

    })();
    testStr = ((function() {
      var _i, _results;
      _results = [];
      for (i = _i = 0; _i <= 15; i = ++_i) {
        _results.push("This is a test in order to test if the TextHeatMap works properly. The word test should be highlighted because it is often used (this as a test).");
      }
      return _results;
    })()).join(" ");
    map = new TextHeatMap(testStr);
    return map.visualize();
  });

}).call(this);

/*
//@ sourceMappingURL=TextHeatMap.map
*/