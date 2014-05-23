VKNews.factory 'SyncStorage', ['$q', ($q) ->
  getValue: (name)->
    deferred = $q.defer()
    chrome.storage.sync.get(name, (data)->deferred.resolve(data[name]))
    deferred.promise

  setValue: (object)->
    deferred = $q.defer()
    chrome.storage.sync.set object, ->deferred.resolve()
    deferred.promise

  clearValues: ->
    deferred = $q.defer()
    chrome.storage.sync.clear ->deferred.resolve()
    deferred.promise

  removeValues: (keys)->
    deferred = $q.defer()
    chrome.storage.sync.remove keys, ->deferred.resolve()
    deferred.promise
]
