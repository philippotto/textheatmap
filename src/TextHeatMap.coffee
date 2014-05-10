require.config(
  baseUrl: 'js/libs'
)

require(["jquery", "d3.v3", "lodash", "quill"], (jQuery, ignoreMe, lodash, Quill) ->

  getColor = d3.scale.category20c()

  colors = ["#fff5f0","#fee0d2","#fcbba1","#fc9272","#fb6a4a","#ef3b2c","#cb181d","#a50f15","#67000d"]

  getColor = (i) ->

    colors[i]


  class TextHeatMap

    visualize: ->

      @initializeQuill()
      @analyzeQuillsText()


    initializeQuill: ->

      @editor = new Quill('#editor');

      debouncedChangeHandler = _.debounce(@analyzeQuillsText.bind(@), 500)

      @editor.on('text-change', =>
        unless @currentlyFormatting
         debouncedChangeHandler()
      )


    analyzeQuillsText: ->

      analysis = @analyzeText(@editor.getText())
      @fillQuill(analysis)


    fillQuill: (analysis) ->

      @currentlyFormatting = true
      console.time("formatting")

      useBatchFormatting = true

      formattingParams = []

      for aWord in analysis.words

        wordCount = analysis.wordCounts[aWord.string.toLowerCase()]

        colorIndex = Math.round(wordCount / analysis.maximum * colors.length - 1)
        colorString = getColor(colorIndex)
        frequency = wordCount / analysis.maximum

        params = [aWord.startIndex, aWord.endIndex, 'color': colorString]
        if useBatchFormatting
          formattingParams.push(params)
        else
          @editor.formatText.apply(@editor, params)

      if useBatchFormatting and formattingParams.length
        @editor.batchFormatText(formattingParams)

      console.timeEnd("formatting")

      @currentlyFormatting = false


    analyzeText: (textString) ->

      console.time("analysis")
      wordPattern = /[\w]+/g

      analysis =
        words : []
        wordCounts : {}
        maximum : 0

      iterationCount = 0

      while (match = wordPattern.exec(textString)) and iterationCount++ < 1000

        currentWord = {
          string : match[0]
          startIndex : match.index
          endIndex : match.index + match[0].length
        }

        wordAsLowerCase = currentWord.string.toLowerCase()
        analysis.wordCounts[wordAsLowerCase] = analysis.wordCounts[wordAsLowerCase] + 1 or 1

        analysis.words.push(currentWord)

      analysis.maximum = _.max(analysis.wordCounts)
      console.timeEnd("analysis")

      return analysis


  map = new TextHeatMap()
  map.visualize()

)