PopupCtrl = ($scope, $rootScope, API, Authentication, Group, Post) ->
  $scope.groups = []
  $scope.posts = []

  Group.query().then (groups)->
    $scope.groups = groups
    console.log 'Groups', groups

  Authentication.getAccessToken().then (token) ->
    $scope.accessToken = token

    Post.query(token).then (posts)->
      console.log 'Posts', posts
      $scope.posts = posts.posts

  $scope.postGroup = (post) ->
    result = $scope.groups.filter (element, index) ->
      element if element.gid is post.to_id.toString()

    if result.length > 0
      result[0]
    else
      {}

  $scope.signOut = ->
    $scope.accessToken = null
    Authentication.cleanSession()

  $scope.authenticate = ->
    Authentication.authenticate().then (result) ->
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
  'Authentication',
  'Group',
  'Post',
  PopupCtrl
]
