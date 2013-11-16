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
    Visuals::drawGraph()
  listen: () ->
    $('#lightbox').on 'click', '.light-close', (e) ->
      BudgetMo::ui.lightbox.hide()
    $('.graph-picker').on 'click', 'a', (e) ->
      sector = $(@).data('sector')
      Visuals::updateGraph(sector)

  ui: {
    vars: {
      breadcrumbs: []
      page: {}
      content_tpl: "home"
    }
    build: () ->

    lightbox: {
      show: () ->
        $('#lightbox').show()
      hide: () ->
        $('#lightbox').hide()
    }
  }

class Visuals
  constructor: () ->
  vars: {
    data: {
      total: 10000000000
      tempTotal: this.total
      gov: [10,50,80,30, 150]
      collated: [60,70,80, 90,100]
      custom: {"name":{"id":"3","full_name":"Darll2","user_type":"citizen","email":"aryll2@gov.ph"},"allocations":[{"sector":"Social Services","budget_allocation":"97","amount":"942800000","category_id":"1","assignments":[{"full_name":"Health facility","amount":"5","unit":""},{"full_name":"Health worker","amount":"117045","unit":""},{"full_name":"Classroom","amount":"873028","unit":""},{"full_name":"Teacher","amount":"259082","unit":""},{"full_name":"Textbook","amount":"195","unit":""}]},{"sector":"Economic Services","budget_allocation":"96","amount":"990200000","category_id":"2","assignments":[{"full_name":"Road","amount":"12","unit":"per km"},{"full_name":"Seedline","amount":"38","unit":""},{"full_name":"Fist port","amount":"416","unit":""},{"full_name":"Fertilizer","amount":"347","unit":"per sack"},{"full_name":"Livestock","amount":"34","unit":""}]},{"sector":"General Public Services","budget_allocation":"96","amount":"964500000","category_id":"3","assignments":[{"full_name":"Carrier truck","amount":"3","unit":""},{"full_name":"Business permit","amount":"4464","unit":""},{"full_name":"NBI clearance","amount":"150","unit":""},{"full_name":"Passport","amount":"2407","unit":""},{"full_name":"NBI clearance","amount":"150","unit":""},{"full_name":"Visa","amount":"328","unit":""}]},{"sector":"Debt Burden","budget_allocation":"97","amount":"977600000","category_id":"4","assignments":[{"full_name":"Debt","amount":"338","unit":"total"}]},{"sector":"Defense","budget_allocation":"9","amount":"92900000","category_id":"5","assignments":[{"full_name":"Aircraft","amount":"35","unit":"per plane"},{"full_name":"Flood control structure","amount":"46","unit":""},{"full_name":"Vehicular radio","amount":"2","unit":""}]}]}
    }
  }
  init: () ->
    height = 400
    width = 400
    color = d3.scale.category20b()
    radius = 150
  drawGraph: () ->
    sum = 0
    height = "100%"
    width = "100%"
    radius = 150
    defSector = Visuals::vars.data.custom.allocations[0]
    for i in Visuals::vars.data.custom.allocations
      sum += parseInt(i.amount)

    data = [0, Visuals::vars.data.total]
    
    color = ["#fcc427", "#999"]
    image = "social"
    canvas = d3.select(".graph-preview .graph")
              .append("svg")
              .style("width", width)
              .style("height", height)
    arc = d3.svg.arc()
          .outerRadius(radius)
          .innerRadius(radius * 0.8)
    layout = d3.layout.pie().sort(null).value( (d) ->
      return d
    )

    group = canvas.append("g")
            .attr("class", "graph-group")
            .attr("transform", "translate(300,200)")
    group.append("circle")
          .attr("cx", 0)
          .attr("cy", 0)
          .attr("r", radius * 0.8)
          .attr("fill", "white")
    group.append("image")
            .attr("xlink:href", "assets/img/#{image}-150.png")
            .attr("x", (radius) / 2 * -1)
            .attr("y", (radius) / 2 * -1)
            .attr("width", radius)
            .attr("height", radius)
    arcs = group.selectAll(".arc")
            .data(layout(data))
            .enter()
            .append("g")
            .attr("class", "arc")
    doughnut = arcs.append("path")
              .attr("d", arc)
              .attr("fill", (d, i) ->
                return color[i]
              )
              .attr("stroke", "#fff")
              .attr("stroke-width", 2)
    $(".a, .b, .c, .d").width((data[0] / (data[0] + data[1]) * 100) + "%")
    $('.total-budget').text(Visuals::vars.data.total)
    $( "#slider-range-min" ).slider({
      range: "min",
      value: data[0] / (data[0] + data[1]) * 100
      min: 0,
      max: 100,
      slide: ( event, ui ) ->
        $(".a, .b, .c, .d").width(ui.value + "%")
        Visuals::vars.data.tempTotal = Visuals::vars.data.total - ui.value / 100 * (Visuals::vars.data.total)
        update(data[0], ui.value / 100 * Visuals::vars.data.total)
    });
    $(".ui-slider-handle").html("&#xf053;&#xf054;");
    update = (old,value) ->
      newData = [value, Visuals::vars.data.total - value]
      arcs.data(layout(newData));
      arcs.select("path").attr("d", arc)
  updateGraph: (sector) ->
      console.log Visuals::vars.data.tempTotal


  tempLightboxGraph: () ->
    Visuals::drawGraph()
      
    
    
$(document).ready () ->
  app = new BudgetMo
  app.init()