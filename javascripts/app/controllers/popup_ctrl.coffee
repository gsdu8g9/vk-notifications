PopupCtrl = ($scope, $rootScope, API, Authorization, Group) ->
  $scope.groups = []

  Group.query().then (result)->
    console.log result
    $scope.groups = result

  Authorization.getAccessToken().then (result) ->
    $scope.accessToken = result

  $scope.signOut = ->
    $scope.accessToken = null
    Authorization.cleanSession()

  $scope.authenticate = ->
    Authorization.authenticate().then (result) ->
      if result.status
        $scope.accessToken = result.accessToken

  # Open options tab, if the tab is already opened switch to one
  #
  $scope.openOptions = ->
    chrome.runtime.sendMessage {action: "open_options_page"}

  # Mark all new posts as read
  #
  $scope.readAll = ->
    chrome.runtime.sendMessage {action: "watch_post", read: 'ALL'}

VKNews.controller 'PopupCtrl', [
  '$scope',
  '$rootScope',
  'API',
  'Authorization',
  'Group',
  PopupCtrl
]
