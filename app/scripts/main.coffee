'use strict'

dartsUi = document.querySelector('darts-ui')
dartsUi.addEventListener 'hit', (event) ->
    {score, ratio} = event.detail
    console.log score + ', ' + ratio + ' = ' + score * ratio

dartsUi.setAttribute 'focuses', '25-2 12-1-o'
