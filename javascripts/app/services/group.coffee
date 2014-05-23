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
    storagePromise = SyncStorage.getValue('group_ids')

    promises = [
      storagePromise.then (groupIds)->
        SyncStorage.removeValues('group_ids').then(->)
        if groupIds
          LocalStorage.removeValues(groupIds).then(->)
    ]
    $q.all(promises)

  save: (item, callback) ->
    if callback and typeof callback is "function"
      callback = callback
    else
      callback = ->

    unless item
      callback({ status: 'error', msg: 'item is not specified' })
      return

    item.gid = "-#{item.gid}"

    chrome.storage.sync.get 'group_ids', (object) =>
      console.log('group_ids', object)

      if angular.equals({}, object)
        group_ids = [item.gid]

        chrome.storage.sync.set { group_ids: group_ids }, ->
          console.log 'saved group_ids for the first time'
      else
        group_ids = object.group_ids

        if group_ids.indexOf(item.gid) < 0
          console.log 'save info about group'

          item_object = {}
          item_object[item.gid] = item

          group_ids.push(item.gid)

          promises = [
            SyncStorage.setValue({ group_ids: group_ids }).then(->),
            LocalStorage.setValue(item_object).then(->)
          ]

          $q.all(promises).then (values) ->
            callback({ status: 'success', values: values })
        else
          console.log 'update info about group'
          callback({ status: 'error', msg: 'group exists' })
          return

        chrome.storage.sync.set { 'group_ids': group_ids }, ->
          console.log 'saved group_ids'

      callback({ status: 'success' })
]
