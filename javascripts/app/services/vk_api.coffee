angular.module('vk_api', []).factory 'API', ['$http', ($http) ->
  call: (method, options) ->
    $http
      method: 'GET'
      url: @requestUrl(method)
      params: options

  requestUrl: (method) ->
    "https://api.vk.com/method/" + method.toString()
]
