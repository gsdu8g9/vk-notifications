window.VKNews = angular.module('vk-news', ['ngSanitize', 'vk_api'])

angular.module('vk-news').run ['Browser', '$log', (Browser, $log)->
  $log.info '## Application initialization'

  Browser.onInstalled.addListener (a) ->
    $log.info '## Processing onInstalled event'
    $log.info 'Reason:', a.reason
    $log.info 'Previous Version:', a.previousVersion

    Browser.alarms.create 'update_posts',
      when: Date.now() + 1000
      periodInMinutes: 1.0

  Browser.alarms.onAlarm.addListener (alarm)->
    $log.info "## Execute onAlarm event `#{alarm.name}`"

    if alarm.name is 'update_posts'
      # TODO: here should go update post handler
      Browser.setBadgeValue(1)
]
