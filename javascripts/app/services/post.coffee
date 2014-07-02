VKNews.factory 'Post', ['$q', 'LocalStorage', 'SyncStorage', 'API', ($q, LocalStorage, SyncStorage, API) ->
  query: (token)->
    deferred = $q.defer()

    if token
      storagePromise = SyncStorage.getValue('group_ids')
      storagePromise.then (groupIds)->
        promises = []
        for key, item of groupIds
          promises.push API.call('wall.get', {owner_id: item, count: 10, access_token: token})

        $q.all(promises).then (result)->
          deferred.resolve result
    else
      deferred.resolve []

    deferred.promise
]
