angular.module('vk-news').filter 'groupLink', ->
  (input) ->
    input = input || '';

    "http://vk.com/#{input}"
