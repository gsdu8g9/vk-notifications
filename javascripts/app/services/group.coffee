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


  clearAll: ->
    deferred = $q.defer()

    chrome.storage.sync.get 'group_ids', (object) ->
      deferred.resolve object['group_ids']

    promises = [
      deferred.promise.then (groupIds)->
        SyncStorage.removeValues('group_ids').then(->)
        if groupIds
          LocalStorage.removeValues(groupIds).then(->)
    ]
    $q.all(promises)

]
