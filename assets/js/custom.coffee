height = 600
width = 1000

expanded = false

govData = [10,50,80,30, 150]
customData = [60,70,80, 90,100]

# ui thing, like color, radius, position etc
color = d3.scale.category20b()
radius = 200

canvas = d3.select("body")
          .append("svg")
          .style("width", width)
          .style("height", height)
          .style("position", "absolute")
          .style("top", 100)
          .style("left", '50%')
          .style("margin-left", -1 * width / 2 + "px")
          .style("transform", "translate(10, '-50%')")

# general chart props
arc = d3.svg.arc()
      .outerRadius(radius)
      .innerRadius(radius * 0.4)

layout = d3.layout.pie()
        .value( (d) ->
          return d
        )

# customGroup
customGroup = canvas.append("g")
              .attr("class", "customGroup")
              .attr("transform", "translate(200,200)")

customArcs = customGroup.selectAll(".custom-arc")
            .data(layout(customData))
            .enter()
            .append("g")
            .attr("class", "arc custom-arc")

customDoughnut = customArcs.append("path")
                  .attr("d", arc)
                  .attr("fill", (d) ->
                    return color(d.data)
                  )
                  .attr("stroke", "#fff")
                  .attr("stroke-width", 2)
customGroup.append("circle")
            .classed("collapse", true)
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
        .classed("collapse", true)
        .classed("nav", true)
        .attr("cx", 0)
        .attr("cy", 0)
        .attr("r", radius * 0.4 - 10)
        .attr("fill", color(radius * 0.4 - 10))
        # .on("click", (d) ->
        #   if not expanded
        #     r = radius / 2
        #     arc.outerRadius(r)
        #       .innerRadius(r * 0.4)
        #     govDoughnut.transition()
        #               .duration(1000)
        #               .ease("elastic")
        #               .attr("d", arc)
        #     govGroup.select(".nav").transition()
        #               .duration(1000)
        #               .ease("elastic")
        #               .attr("r", r * 0.4 - 10)
        # )