angular.module('vk-news').directive('groupLink', function () {
  return function (scope, element, attrs) {
    var group = scope.$eval(attrs.groupLink);

    element.attr('href', 'https://vk.com/' + group.screen_name);
  }
})

