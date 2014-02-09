'use strict'

angular.module('d3vizApp')
  .controller 'UserDashboard', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
      'd3'
      'jquery'
    ]
    $scope.mockUser =
      expected: 0.9
      actual: 0.95

  .directive 'visualization', ($window)->
    restrict: 'E'
    scope: true
    formatNumber: (number) ->
      number = parseFloat(number)
      if !(0 <= number <= 1)
        number = 0
      return number
    togglePercentage: (element, attributes) ->
      d3.select('text').text()
    compile: (element, attributes) ->
      self = @
      actualPercent = @formatNumber(attributes.actual)
      expectedPercent = @formatNumber(attributes.expected)

      containerWidth = $(element).parent().width()

      actual = d3.svg.arc().innerRadius(62).outerRadius(70).startAngle(0).endAngle(actualPercent * 360 * (Math.PI/180))
      expected = d3.svg.arc().innerRadius(55).outerRadius(59).startAngle(0).endAngle(expectedPercent * 360 * (Math.PI/180))
      circleContainer = d3.select(element[0]).append('svg')
                                            .attr('width', containerWidth)
                                            .attr('height', 200)
                                            .on "click", (d) ->
                                              element = $(this).parents('visualization')
                                              if element.data('display') == 'actual'
                                                d3.select('text').text("#{element.data('expected') * 100}%")
                                                element.data('display', 'expected')
                                              else 
                                                d3.select('text').text("#{element.data('actual') * 100}%").attr('data-display', 'actual')
                                                element.data('display', 'actual')
      # append lines and percentage text
      circleContainer.append("path")
                    .attr("d", expected)
                    .attr("transform", "translate(70,75)")
                    .attr("data-type", "expected")
                    .style("fill", "#FFFFFF")
                  .transition()
                    .delay(100)
                    .duration(5000)    
                    .style("fill", "#c8e49a");
      myPath = circleContainer.append("path")
                    .attr("d", actual)
                    .attr("transform", "translate(70,75)")
                    .attr("fill", "#FFFFFF")
                  .transition()
                    .delay(100)
                    .duration(5000)    
                    .style("fill", "#7abe23");

      circleContainer.append('text')
                    .text("#{actualPercent * 100}%")
                    .style("fill", "black")
                    .attr("dx", 50)
                    .attr("dy", 75)