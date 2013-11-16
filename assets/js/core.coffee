class BudgetMo
  constructor: ->
  vars: {
    base_url: "/",
    tpl_path: "public/tpl/",
    user: "anonymous",
    logged: 0
  },
  init: () ->
    this.ui.build()
    this.listen()
  listen: () ->
    $('#lightbox').on 'click', '.light-close', (e) ->
      BudgetMo::ui.lightbox.hide()

  ui: {
    vars: {
      breadcrumbs: []
      page: {}
      content_tpl: "home"
    }
    build: () ->

    lightbox: {
      show: () ->
        $('.overlay').show()
        $('#lightbox').show()
      hide: () ->
        $('.overlay').hide()
        $('#lightbox').hide()

    }
  }

class Visuals
  constructor: () ->
  vars: {
    data: {
      gov: [10,50,80,30, 150]
      collated: [60,70,80, 90,100]
      custom: []
    }
  }
  init: () ->
    height = 500
    width = 500
    color = d3.scale.category20b()
    radius = 150

  


$(document).ready () ->
  app = new BudgetMo
  app.init()