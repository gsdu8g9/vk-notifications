Authentication = ($q, $log, UrlHelpers) ->
  _listenerHandler: (authenticationTabId) ->
    tabUpdateListener = (tabId, changeInfo) =>
      if tabId is authenticationTabId and changeInfo.url and changeInfo.status is "loading"
        if changeInfo.url.indexOf('oauth.vk.com/blank.html') > -1
          authenticationTabId = null
          chrome.tabs.onUpdated.removeListener(tabUpdateListener)

          accessToken = UrlHelpers.getParameterValue(changeInfo.url, 'access_token')

          if !accessToken?.length?
            $log.error('VK Auth Response problem:', 'access_token is undefined')
            return

          accessTokenExpiredFlag = parseInt(UrlHelpers.getParameterValue(changeInfo.url, 'expires_in'), 10)

          if accessTokenExpiredFlag isnt 0
            $log.error('VK Auth Response problem:', "access_token `#{accessToken}` is expired")
            return

          @setAccessToken(accessToken).then ->
            chrome.tabs.remove tabId

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
    deferred = $q.defer()

    chrome.storage.local.set {'vkaccess_token': token}, ->
      deferred.resolve()

    deferred.promise

  getAccessToken: ->
    deferred = $q.defer()

    chrome.storage.local.get 'vkaccess_token': null, (items) ->
      deferred.resolve(items.vkaccess_token)

    deferred.promise

  cleanSession: ->
    chrome.storage.local.remove 'vkaccess_token'

  execute: ->
    clientId           = '3696318'
    requestedScopes    = 'offline'
    authUrl  = "https://oauth.vk.com/authorize?client_id=#{clientId}&scope=#{requestedScopes}&redirect_uri=http%3A%2F%2Foauth.vk.com%2Fblank.html&display=page&response_type=token"

    chrome.tabs.create {url: authUrl, selected: true}, (tab) =>
      chrome.tabs.onUpdated.addListener(@_listenerHandler(tab.id))

angular.module('vk-news').factory 'Authentication', [
  '$q', '$log', 'UrlHelpers', Authentication
]
