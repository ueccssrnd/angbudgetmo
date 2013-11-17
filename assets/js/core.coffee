class BudgetMo
  constructor: ->
  vars: {
    base_url: "/",
    tpl_path: "public/tpl/",
    user: "anonymous",
    logged: 0
    counter: 0
  },
  init: () ->
    if Visuals::vars.data.total is 0

      for i in Visuals::vars.data.custom.allocations
        Visuals::vars.data.total += parseInt(i.amount)
        if i.sector is "Debt Burden"
          Visuals::vars.data.total -= parseInt(i.amount)
    $('.total-budget span').text(Visuals::vars.data.total)
    this.ui.build()
    this.listen()
    Visuals::drawGraph()
    $('.graph-picker a:first').click()
    
  listen: () ->
    $('#lightbox').on 'click', '.light-close', (e) ->
      BudgetMo::ui.lightbox.hide()
    $('.graph-picker').on 'click', 'a', (e) ->
      sector = $(@).data('sector')
      Visuals::vars.data.total =  parseInt($('.total-budget span').text())
      $('.total-budget span').text(Visuals::vars.data.total)
      Visuals::updateGraph(sector)
      $('.graph-parts-nav').find('a.active').removeClass('active')
      $(@).addClass('active')
      serviceList = $('.bubble').find('ul').html("")
      numberWithCommas = (x) ->
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      $('.cat-sector').text(Visuals::vars.data.custom.allocations[sector].sector)
      $('.sector-budget').find('.cash').text(Visuals::vars.data.custom.allocations[sector].budget_allocation + "M")
      for k, v of Visuals::vars.data.custom.allocations[sector].assignments
        sum = 0
        for i in Visuals::vars.data.custom.allocations
          sum = Visuals::vars.data.total + parseInt(i.amount)
        serviceList.append("<li><img src='assets/img/#{v.image}' alt=''><p><span class='items-count'>#{numberWithCommas((sum -  Visuals::temp.remaining) / v.amount)}</span> <span class='item-name'>#{v.full_name}</span> (<span class='item-price'>#{v.amount} </span>)")
  ui: {
    vars: {
      breadcrumbs: []
      page: {}
      content_tpl: "home"
    }
    build: () ->
      sectors = Visuals::vars.data.custom.allocations
      for k, v of sectors
        if v.sector isnt "Debt Burden"
          $('.graph-parts-nav').append("<li class='graph-picker'><a href='#' data-sector='#{k}'><img src='assets/img/#{v.image}'></a></li>")

      height = 500
      width = 1000

      expanded = false

      govData = [10,50,80,30, 150]
      collatedData = [60,70,80, 90,100]

      # ui thing, like color, radius, position etc
      color = d3.scale.category20b()
      radius = 150

      canvas = d3.select("#content")
                .append("svg")
                .style("width", width)
                .style("height", height)
                .style("position", "absolute")
                .style("top", 100)
                .style("left", '50%')
                .style("margin-left", -1 * width / 2 + "px")
                .style("transform", "translate(10, '-50%')")

      line = canvas.append("line")
              .attr("x1", 500)
              .attr("x2", 500)
              .attr("y1", 0)
              .attr("y2", 500)
              .attr("stroke", "#ccc")
              .attr("stroke-width", 2)

      # general chart props
      arc = d3.svg.arc()
            .outerRadius(radius)
            .innerRadius(radius * 0.4)

      layout = d3.layout.pie()
              .value( (d) ->
                return d
              )

      # collatedGroup
      collatedGroup = canvas.append("g")
                    .attr("class", "collatedGroup")
                    .attr("transform", "translate(200,200)")

      collatedArcs = collatedGroup.selectAll(".collated-arc")
                  .data(layout(collatedData))
                  .enter()
                  .append("g")
                  .attr("class", "arc collated-arc")

      collatedDoughnut = collatedArcs.append("path")
                        .attr("d", arc)
                        .attr("fill", (d) ->
                          return color(d.data)
                        )
                        .attr("stroke", "#fff")
                        .attr("stroke-width", 2)
      collatedGroup.append("circle")
                  .classed("nav-collapse", true)
                  .attr("cx", 0)
                  .attr("cy", 0)
                  .attr("r", radius * 0.4 - 10)
                  .attr("fill", color(radius * 0.4 - 10))

      # govGroup
      govGroup =  canvas.append("g")
                  .attr("class", "govGroup")
                  .attr("transform", "translate(800,200)")

      govArcs = govGroup.selectAll(".gov-arc")
                  .data(layout(govData))
                  .enter()
                  .append("g")
                  .attr("class", "arc gov-arc")
      govDoughnut = govArcs.append("path")
                    .attr("d", arc)
                    .attr("fill", (d) ->
                      return color(d.data)
                    )
                    .attr("stroke", "#fff")
                    .attr("stroke-width", 2)
      govGroup.append("circle")
              .classed("nav-collapse", true)
              .classed("nav", true)
              .attr("cx", 0)
              .attr("cy", 0)
              .attr("r", radius * 0.4 - 10)
              .attr("fill", color(radius * 0.4 - 10))

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
      total: 0
      gov: [10,50,80,30, 150]
      collated: [60,70,80, 90,100]
      custom: {"user":{"id":"1","full_name":"Government 2014","user_type":"government","email":"government@gov.ph"},"allocations":[{"sector":"Social Services","budget_allocation":"37","amount":"842800000","category_id":"1","image":"social.png","assignments":[{"full_name":"Health facility","amount":"5","unit":"","image":"hospital.png"},{"full_name":"Health worker","amount":"117045","unit":"","image":"nurse.png"},{"full_name":"Classroom","amount":"873028","unit":"","image":"school.png"},{"full_name":"Teacher","amount":"259082","unit":"","image":"teacher.png"},{"full_name":"Textbook","amount":"195","unit":"","image":"book.png"}]},{"sector":"Economic Services","budget_allocation":"26","amount":"590200000","category_id":"2","image":"economic.png","assignments":[{"full_name":"Road","amount":"12","unit":"per km","image":"road.png"},{"full_name":"Seedling","amount":"38","unit":"","image":"seedling.png"},{"full_name":"Fist port","amount":"416","unit":"","image":"fishport.png"},{"full_name":"Fertilizer","amount":"347","unit":"per sack","image":"fertilizer.png"},{"full_name":"Livestock","amount":"34","unit":"","image":"livestock.png"}]},{"sector":"General Public Services","budget_allocation":"16","amount":"364500000","category_id":"3","image":"public.png","assignments":[{"full_name":"Carrier truck","amount":"3","unit":"","image":"truck.png"},{"full_name":"Business permit","amount":"4464","unit":"","image":"businesspermit.png"},{"full_name":"NBI clearance","amount":"150","unit":"","image":"nbi.png"},{"full_name":"Passport","amount":"2407","unit":"","image":"passport.png"},{"full_name":"Visa","amount":"328","unit":"","image":"visa.png"}]},{"sector":"Debt Burden","budget_allocation":"17","amount":"377600000","category_id":"4","image":"debt.png","assignments":[{"full_name":"Debt","amount":"338","unit":"total","image":"debt.png"}]},{"sector":"Defense","budget_allocation":"4","amount":"92900000","category_id":"5","image":"defense.png","assignments":[{"full_name":"Aircraft","amount":"35","unit":"per plane","image":"jet.png"},{"full_name":"Flood control structure","amount":"46","unit":"","image":"floodcontrol.png"},{"full_name":"Vehicular radio","amount":"2","unit":"","image":"radio.png"}]}]}
    }
  },
  temp: {
    remaining: 0
    current: 0
    saved: []
  }, 
  init: () ->
    height = 400
    width = 400
    color = d3.scale.category20b()
    radius = 150
  drawGraph: () ->
    height = "100%"
    width = "100%"
    radius = 150
    currentSector = if $('.graph-picker').find('a.active').data('sector') is undefined then 0 else $('.graph-picker').find('a.active').data('sector')
    
    data = [0, Visuals::vars.data.total]
    
    color = ["gold","#999"]
    image = Visuals::vars.data.custom.allocations[currentSector].image
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
            .attr("xlink:href", "assets/img/#{image}")
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
    $(".a, .b, .c, .d").width(0)
    $( "#slider-range-min" ).slider({
      range: "min",
      value: 0
      min: 0,
      max: 100,
      slide: ( event, ui ) ->
        numberWithCommas = (x) ->
          return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        $(".a, .b, .c, .d").width(ui.value + "%")
        Visuals::temp.current = ui.value / 100 * Visuals::vars.data.total
        $('.sector-budget').find('.cash').text(Visuals::temp.current)

        Visuals::temp.remaining = (100 - ui.value) / 100 * Visuals::vars.data.total
        $('.total-budget span').text(Math.round(Math.ceil(Visuals::temp.remaining)))
        update(Visuals::vars.data.total -  Visuals::temp.remaining, Visuals::temp.remaining)

        currentSector = if $('.graph-picker').find('a.active').data('sector') is undefined then 0 else $('.graph-picker').find('a.active').data('sector')

        serviceList = $('.bubble').find('ul').html("")
        $('.cat-sector').text(Visuals::vars.data.custom.allocations[currentSector].sector)
        $('.sector-budget').find('.cash').text("P" + numberWithCommas(Visuals::temp.current) + " (#{ui.value}%)")
        for k, v of Visuals::vars.data.custom.allocations[currentSector].assignments
          serviceList.append("<li><img src='assets/img/#{v.image}' alt=''><p><span class='items-count'>#{numberWithCommas(Visuals::temp.current / v.amount)}</span> <span class='item-name'>#{v.full_name}</span> (<span class='item-price'>#{v.amount} </span>)")
    });
    $(".ui-slider-handle").html("&#xf053;&#xf054;");
    update = (value, remaining) ->
      newData = [value, remaining]
      arcs.data(layout(newData));
      arcs.select("path").attr("d", arc)


  updateGraph: (sector) ->
      $("#slider-range-min").slider("value", $("#slider-range-min").slider("option", "min") );
      $(".a, .b, .c, .d").width(0)
      arc = d3.svg.arc()
          .outerRadius(radius)
          .innerRadius(radius * 0.8)
      layout = d3.layout.pie().sort(null).value( (d) ->
        return d
      )
      radius = 150
      canvas = d3.select(".graph-preview")
      group = canvas.select(".graph-group")
      image = group.select("image")
              .attr("xlink:href", "assets/img/#{Visuals::vars.data.custom.allocations[sector].image}")
    
$(document).ready () ->
  app = new BudgetMo
  app.init()