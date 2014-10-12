angular.module('vk-news').factory 'UrlHelpers', [->
  # Retrieve a value of a parameter from the given URL string
  #
  # @param  {string} url           Url string
  # @param  {string} parameterName Name of the parameter
  #
  # @return {string}               Value of the parameter
  getParameterValue: (url, parameterName) ->
    urlParameters  = url.substr(url.indexOf('#') + 1)
    parameterValue = ''

    urlParameters = urlParameters.split('&')

    for param in urlParameters
      temp = param.split('=')

      return temp[1] if temp[0] is parameterName

    parameterValue
]
