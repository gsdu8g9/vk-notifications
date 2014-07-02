PopupCtrl = ($scope, $rootScope, API, Authorization, Group, Post) ->
  $scope.groups = []
  $scope.posts = []

  Group.query().then (groups)->
    console.log groups
    $scope.groups = groups

  Authorization.getAccessToken().then (token) ->
    $scope.accessToken = token

    Post.query(token).then (posts)->
      $scope.posts = posts
      console.log $scope.posts

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
  'Post',
  PopupCtrl
]
