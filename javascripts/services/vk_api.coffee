VKNews.factory 'API', ['$http', ($http) ->
  call: (method, options, callback) ->
    $http({
      method: 'GET',
      url: @requestUrl(method),
      params: options
    }).success(callback).error(callback)

  requestUrl: (method) ->
    "https://api.vk.com/method/" + method.toString()
]
