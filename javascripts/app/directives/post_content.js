angular.module('vk-news').directive('postContent', ['$filter', function ($filter) {
  var formatText = $filter('formatText');

  function attachmentsTemplate(attachments) {
    if (!attachments) return '';

    var photos = angular.element('<div />', {class: 'photos'});
    var links = angular.element('<div />', {class: 'links'});

    angular.forEach(attachments, function (attachment, key) {
      if (attachment.type === "photo") {
        photos.append(angular.element('<img />', {src: attachment.photo.src, class: 'photo'}))
      }

      if (attachment.type === "link") {
        links.append(angular.element('<a />', {href: attachment.link.url, text: attachment.link.url, class: 'link'}))
      }
    });

    return angular.element('<div />', {class: 'attachments'}).append(photos).append(links).html()
  }

  function postTemplate (post) {
    var text = formatText(post.text);

    return '<div class="text">' + text + '</div>' + attachmentsTemplate(post.attachments)
  }

  return function (scope, element, attrs) {
    var post = scope.$eval(attrs.postContent);

    element.html(postTemplate(post));
  }
}])
