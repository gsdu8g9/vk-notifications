VKNews.factory 'Authorization', ['$q', ($q) ->
  authenticate: ->
    deferred = $q.defer()

    chrome.runtime.sendMessage {action: "vk_notification_auth"}, (response) =>
      if response.content is 'OK'
        @getAccessToken().then (result)->
          deferred.resolve {
            status: true,
            access_token: result
          }
      else
        deferred.resolve({
          status: false
        })

    deferred.promise


  setAccessToken: (token) ->

  getAccessToken: ->
    deferred = $q.defer()

    chrome.storage.local.get 'vkaccess_token': null, (items) ->
      deferred.resolve(items.vkaccess_token)

    deferred.promise

  cleanSession: ->
    chrome.storage.local.remove 'vkaccess_token'
]
