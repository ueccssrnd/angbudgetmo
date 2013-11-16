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
  ui: {
    vars: {
      breadcrumbs: []
      page: {}
      content_tpl: "home"
    }
    build: () ->
      
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