angular.module('vk-news').factory 'Group', ['$q', 'LocalStorage', 'SyncStorage', ($q, LocalStorage, SyncStorage) ->
  query: ->
    deferred = $q.defer()
    storagePromise = SyncStorage.getValue('group_ids')

    storagePromise.then (groupIds)->
      promises = []
      for key, item of groupIds
        promises.push(LocalStorage.getValue(item))

      $q.all(promises).then (result)->
        deferred.resolve result

    deferred.promise


  clearAll: ->
    storagePromise = SyncStorage.getValue('group_ids')

    promises = [
      storagePromise.then (groupIds)->
        SyncStorage.removeValues('group_ids').then(->)
        if groupIds
          LocalStorage.removeValues(groupIds).then(->)
    ]
    $q.all(promises)


  save: (item) ->
    deferred = $q.defer()
    return deferred.resolve({ status: 'error', msg: 'item is not specified' }).promise unless item

    item.gid = "-#{item.gid}"

    SyncStorage.getValue('group_ids').then (groupIds) ->
      groupIds = groupIds || []

      if groupIds.indexOf(item.gid) < 0
        console.log 'save info about group'

        itemObject = {}
        itemObject[item.gid] = item

        console.log itemObject

        groupIds.push(item.gid)

        promises = [
          SyncStorage.setValue({ group_ids: groupIds }).then(->),
          LocalStorage.setValue(itemObject).then(->)
        ]

        $q.all(promises).then (values) ->
          deferred.resolve({ status: 'success', values: values })
      else
        console.log 'update info about group'
        deferred.resolve({ status: 'error', msg: 'group exists' })

    deferred.promise


  remove: (groupId)->
    storagePromise = SyncStorage.getValue('group_ids')

    $q.all(storagePromise.then (groupIds)->
      groupIds.splice(groupIds.indexOf(groupId), 1)
      SyncStorage.setValue({ group_ids: groupIds }).then(->)
      if groupIds
        LocalStorage.removeValues(groupId).then(->)
    )
]
