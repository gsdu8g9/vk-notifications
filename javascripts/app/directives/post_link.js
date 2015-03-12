angular.module('vk-news').directive('postLink', function () {
  return function (scope, element, attrs) {
    var post = scope.$eval(attrs.postLink);

    element.attr('href', 'https://vk.com/' + post.group.screen_name + '?w=wall' + post.to_id + '_' + post.id);
  }
})

