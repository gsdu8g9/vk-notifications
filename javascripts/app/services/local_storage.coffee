VKNews.factory 'LocalStorage', ['$q', ($q) ->
  getValue: (name)->
    deferred = $q.defer()
    chrome.storage.local.get(name, (data)->deferred.resolve(data[name]))
    deferred.promise

  setValue: (object)->
    deferred = $q.defer()
    chrome.storage.local.set object, ->deferred.resolve()
    deferred.promise

  clearValues: ->
    deferred = $q.defer()
    chrome.storage.local.clear ->deferred.resolve()
    deferred.promise
]
