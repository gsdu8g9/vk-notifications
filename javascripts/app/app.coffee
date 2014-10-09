window.VKNews = angular.module('vk-news', ['ngSanitize', 'vk_api'])

angular.module('vk-news').run ['Browser', '$log', (Browser, $log)->
  $log.info '## Application initialization'

  chrome.runtime.onInstalled.addListener (a)->
    $log.info '## Processing onInstalled event'
    $log.info 'Reason:', a.reason
    $log.info 'Previous Version:', a.previousVersion

    chrome.alarms.create "update_posts",
      when: Date.now() + 1000
      periodInMinutes: 1.0

  Browser.setBadgeValue(7)
]
