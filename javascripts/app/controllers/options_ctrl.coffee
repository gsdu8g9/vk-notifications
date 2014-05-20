OptionsCtrl = ($scope, $rootScope, API, Authorization, Group) ->
  $scope.groups = []

  Group.query().then (result)->
    $scope.groups = result

  Authorization.getAccessToken().then (result) ->
    $scope.accessToken = result

  $scope.authenticate = ->
    Authorization.authenticate().then (result) ->
      if result.status
        $scope.accessToken = result.accessToken

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

    API.call 'groups.getById', {group_ids: shortName[1], access_token: $scope.accessToken}, (data) ->
      console.log data
      unless data.error
        console.log 'save item here'
        # addGroupItemToStroage data.response[0], success: ->
        #   $pageUrl.remove()
        #   $self.remove()
        #   drawGroupItem($parent, data.response[0])
        $scope.groups.push data.response[0]
      else
        $scope.groupForm.hasError = 'Группа не найдена'
        $scope.groupForm.isSaving = false
        return

    $scope.groupForm.isSaving = false

VKNews.controller 'OptionsCtrl', [
  '$scope',
  '$rootScope',
  'API',
  'Authorization',
  'Group',
  OptionsCtrl
]
