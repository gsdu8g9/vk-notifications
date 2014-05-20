OptionsCtrl = ($scope, $rootScope, API, Authorization) ->
  $scope.pageUrl = ''
  $scope.isItemFormShowed = false
  $scope.isSaving = false
  $scope.hasError = false
  $scope.errorMessage = ''
  $scope.groups = []

  Authorization.getAccessToken().then (result) ->
    $scope.accessToken = result

  $scope.authenticate = ->
    Authorization.authenticate().then (result) ->
      if result.status
        $scope.accessToken = result.accessToken

  $scope.showItemForm = ->
    $scope.pageUrl = ''
    $scope.isItemFormShowed = true

  $scope.saveGroupItem = ->
    $scope.isSaving = true
    $scope.hasError = false

    url = $scope.pageUrl
    shortName = url.match(/vk.com\/(\w+)/)

    unless shortName
      $scope.hasError = 'Неверный формат ссылки'
      $scope.isSaving = false
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
        $scope.hasError = 'Группа не найдена'
        $scope.isSaving = false
        return

    $scope.isSaving = false

VKNews.controller 'OptionsCtrl', [
  '$scope',
  '$rootScope',
  'API',
  'Authorization',
  OptionsCtrl
]
