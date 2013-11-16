class BudgetMo
  constructor: () ->
  init: () ->
    @listen()
  listen: () ->
    mdClose = $('.md-close')
    $('#chart-navi').on 'click', '.btn', (e) ->
      cgroup = $(@).data('cgroup')
      $('.md-modal').addClass('md-show')
  ui: () ->
    

bmhack = new BudgetMo
bmhack.init()