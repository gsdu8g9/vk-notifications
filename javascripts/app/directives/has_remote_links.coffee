angular.module('vk-news').directive 'hasRemoteLinks', ['$document', ($document) ->
  (scope, element, attrs) ->
    angular.element($document).on 'click', 'a', (e) ->
      chrome.tabs.create {url: angular.element(this).attr('href'), selected: true}
      e.preventDefault()
]

