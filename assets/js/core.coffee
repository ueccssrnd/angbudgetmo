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
    Visuals::tempLightboxGraph()
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
        $('#lightbox').show()
      hide: () ->
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
    height = 400
    width = 400
    color = d3.scale.category20b()
    radius = 150
  tempLightboxGraph: () ->
    height = '100%'
    width = '100%'
    sum = (arr) ->
      sum = 0
      for i in arr
        sum += i
      return sum
    otherValues = [30, 10, 80]# total of other values
    sumOtherVal = sum(otherValues)
    data = [50, sumOtherVal]

    color = ["#fcc427", "#888"]

    radius = 150
    
    canvas = d3.select(".graph-preview .graph")
              .append("svg")
              .style("width", width)
              .style("height", height)
    arc = d3.svg.arc()
          .outerRadius(radius)
          .innerRadius(radius * 0.8)
    layout = d3.layout.pie().sort(null)
            .value( (d) ->
              return d
            )
    group = canvas.append("g")
            .attr("transform", "translate(200,200)")

    group.append("circle")
          .attr("cx", 0)
          .attr("cy", 0)
          .attr("r", radius * 0.8)
          .attr("fill", "white")
    group.append("image")
            .attr("xlink:href", "assets/img/social-150.png")
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
    $("#slider").slider({
      value: data[0]
      min: 0
      max: sumOtherVal + data[0]
      step: 1
      slide: (e, ui) ->
        update(data[0], ui.value)
    })

    update = (old,value) ->
      newData = [value, sumOtherVal + old - value]
      difference = Math.floor(Math.round((sumOtherVal - newData[1]) / otherValues.length))
      console.log difference
      arcs.data(layout(newData));
      arcs.select("path").attr("d", arc)
$(document).ready () ->
  app = new BudgetMo
  app.init()