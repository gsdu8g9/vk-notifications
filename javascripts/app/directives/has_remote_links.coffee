angular.module('vk-news').directive 'hasRemoteLinks', ['$document', ($document) ->
  (scope, element, attrs) ->
    angular.element($document).on 'click', 'a', (e) ->
      e.preventDefault()

      href = angular.element(this).attr('href')

      unless href.match(/^#(.+)?/)
        chrome.tabs.create {url: href, selected: true}
]

