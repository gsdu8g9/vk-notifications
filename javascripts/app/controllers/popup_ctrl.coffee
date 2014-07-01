PopupCtrl = ($scope, $rootScope, API, Authorization, Group) ->
  $scope.groups = []

  Group.query().then (result)->
    console.log result
    $scope.groups = result

  Authorization.getAccessToken().then (result) ->
    $scope.accessToken = result

  $scope.signOut = ->


  $scope.authenticate = ->
    Authorization.authenticate().then (result) ->
      if result.status
        $scope.accessToken = result.accessToken

VKNews.controller 'PopupCtrl', [
  '$scope',
  '$rootScope',
  'API',
  'Authorization',
  'Group',
  PopupCtrl
]
