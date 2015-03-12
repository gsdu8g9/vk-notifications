angular.module('vk-news').factory 'LocalStorage', ['$q', ($q) ->
  getValue: (name)->
    deferred = $q.defer()
    chrome.storage.local.get name, (data)->deferred.resolve(data[name])
    deferred.promise

  setValue: (object)->
    deferred = $q.defer()
    chrome.storage.local.set object, ->deferred.resolve()
    deferred.promise

  clearValues: ->
    deferred = $q.defer()
    chrome.storage.local.clear ->deferred.resolve()
    deferred.promise

  removeValues: (keys)->
    deferred = $q.defer()
    chrome.storage.sync.remove keys, ->deferred.resolve()
    deferred.promise
]
