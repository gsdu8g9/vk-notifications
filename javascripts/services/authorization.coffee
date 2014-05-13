VKNews.factory 'Authorization', ['$q', ($q) ->
  setAccessToken: (token) ->

  getAccessToken: ->
    deferred = $q.defer()

    chrome.storage.local.get 'vkaccess_token': null, (items) ->
      deferred.resolve(items.vkaccess_token)

    deferred.promise


]
