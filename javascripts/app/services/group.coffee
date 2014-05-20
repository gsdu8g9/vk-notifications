VKNews.factory 'Group', ['$q', ($q) ->
  query: ->
    deferred = $q.defer()

    chrome.storage.local.get 'group_items': {}, (items) ->
      groupItems = items.group_items
      result = []

      for key, item of groupItems
        result.push(item)

      deferred.resolve result

    deferred.promise
]
