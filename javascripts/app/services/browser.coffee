angular.module('vk-news').factory 'Browser', [->
  # Returns a badge text according to number of posts
  #
  _badgeText: (number) ->
    return '' if number <= 0 or number is undefined
    return '10+' if number > 10
    "#{number}"

  alarms: chrome.alarms,

  onInstalled: chrome.runtime.onInstalled,
  onMessage: chrome.runtime.onMessage,

  setBadgeValue: (value) ->
    chrome.browserAction.setBadgeText({text: @_badgeText(value)})
]
