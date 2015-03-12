OptionsCtrl = ($scope, $rootScope, API, Authentication, Group) ->
  $scope.groups = []

  Group.query().then (result)->
    $scope.groups = result

  Authentication.getAccessToken().then (result) ->
    $scope.accessToken = result

  $scope.authenticate = ->
    Authentication.authenticate().then (result) ->
      if result.status
        $scope.accessToken = result.accessToken

  $scope.removeGroup = (group) ->
    Group.remove(group.gid).then (data)->
      $scope.groups.splice($scope.groups.indexOf(group), 1)

  $scope.clearAllGroups = ->
    Group.clearAll().then ->
      $scope.groups = []

  $scope.showGroupForm = ->
    $scope.groupForm.groupUrl = ''
    $scope.groupForm.editMode = true
    $scope.groupForm.hasError = false
    $scope.groupForm.isSaving = false

  $scope.saveGroupForm = ->
    $scope.groupForm.isSaving = true
    $scope.groupForm.hasError = false

    url = $scope.groupForm.groupUrl
    shortName = url.match(/vk.com\/(\w+)/)

    unless shortName
      $scope.groupForm.hasError = 'Неверный формат ссылки'
      $scope.groupForm.isSaving = false
      return

    eventMatch = shortName[1].match(/event(\d+)/)

    shortName = eventMatch if eventMatch

    API.call('groups.getById', {group_ids: shortName[1], access_token: $scope.accessToken}).then (response) ->
      if response.status is 200
        console.log 'save item execute'
        Group.save(response.data.response[0]).then (result)=>
          console.log(result)
          $scope.groups.push response.data.response[0]
      else
        $scope.groupForm.hasError = 'Группа не найдена'
        $scope.groupForm.isSaving = false
        return

    $scope.groupForm.isSaving = false

angular.module('vk-news').controller 'OptionsCtrl', [
  '$scope',
  '$rootScope',
  'API',
  'Authentication',
  'Group',
  OptionsCtrl
]
