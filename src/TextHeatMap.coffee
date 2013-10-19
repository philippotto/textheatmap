require.config(
  baseUrl: 'js/libs'
)

require(["jquery", "d3.v3", "lodash"],  ->

  getColor = d3.scale.category20c()
  
  colors = ["#fff5f0","#fee0d2","#fcbba1","#fc9272","#fb6a4a","#ef3b2c","#cb181d","#a50f15","#67000d"]

  getColor = (i) ->

    colors[i]


  class TextHeatMap

    constructor: (@text) ->


    visualize: ->
      
      @cleanText = @clean(@text)
      @analyzeText()
      
      @drawTextDIV()


    clean: (s) ->

      
      @originalWords = s.split(" ")
      
      words = (aWord.replace(/[^a-zA-Zäöüß ]/g, "").toLowerCase() for aWord in @originalWords)
      return words


    cleanWord: (s) ->

      return s.replace(/[^a-zA-Zäöüß ]/g, "").toLowerCase()


    analyzeText: ->

      words = {}

      for word in @cleanText
        
        words[word] = words[word] + 1 or 1
        # $("div").append("<span>#{word}</span> ")

      maximum = _.max(words)

      @words = words
      @maximum = maximum


    drawTextSVG: ->

      words = @words
      originalWords = @originalWords
      maximum = @maximum

      text = d3.select("body").append("svg")
        .append("text")
        .attr("x", 30)
        .attr("y", 30)
        .attr("word-spacing", 8)


      currentLine = text.append("tspan")
      
      lineCount = 1

      for aWord, index in originalWords

        BBox = currentLine[0][0].getBBox()

        if index % 20 == 0

          currentLine = text.append("tspan")
                            .attr("x", 100)
                            .attr("dy", 25)
          

        currentLine.append("tspan")
          .text( aWord )
          .attr("font-family", "Lato")
          .attr("dx", 10)
          .style("fill", (w, c) =>
            wordCount = words[aWord]
            getColor(Math.round( wordCount / maximum * 9 - 1 ))
          )
          .on("mouseenter", ->
            

            d3.select(this).transition(100).attr("fill-opacity", 1.0)
            # d3.select("text").selectAll("tspan").filter()
            
          )
          .on("mouseleave", -> d3.select(this).transition(100).attr("fill-opacity", 0.8) )

        

    drawTextDIV: ->

      $("body").append("<div id='HeatMapDiv' style='background: #ffffff; font-family: Lato, sans-serif; padding: 15px'></div>")

      $heatMap = $("#HeatMapDiv")

      for aWord, index in @originalWords

        cleanedWord = @cleanWord(aWord)
        wordCount = @words[cleanedWord]
        colorIndex = Math.round( wordCount / @maximum * 9 - 1 )
        colorString = getColor(colorIndex)

        span = $(document.createElement("span"))
            .text(@originalWords[index] + " ")
            .css("color", colorString)
        
        $heatMap.append(span)



  #################



  testStr = (
    for i in [0..15]
      """This is a test in order to test if the TextHeatMap works properly. The word test should be highlighted because it is often used (this as a test)."""
  ).join(" ")


  map = new TextHeatMap(testStr)
  map.visualize()

)