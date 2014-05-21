VKNews.factory 'Group', ['$q', 'LocalStorage', 'SyncStorage', ($q, LocalStorage, SyncStorage) ->
  query: ->
    deferred = $q.defer()

    chrome.storage.local.get 'group_items': {}, (items) ->
      groupItems = items.group_items
      result = []

      for key, item of groupItems
        result.push(item)

      deferred.resolve result

    deferred.promise

  # TODO: We need to clean only group items without authToken
  clearAll: ->
    promises = [
      SyncStorage.clearValues().then(->),
      LocalStorage.clearValues().then(->)
    ]
    $q.all(promises)

]
