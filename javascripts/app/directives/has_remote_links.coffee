angular.module('vk-news').directive 'hasRemoteLinks', ->
  (scope, element, attrs) ->
    angular.element(element).on 'click', 'a', (e) ->
      e.preventDefault()

      href = angular.element(this).attr('href')

      unless href.match(/^#(.+)?/)
        chrome.tabs.create {url: href, selected: true}

