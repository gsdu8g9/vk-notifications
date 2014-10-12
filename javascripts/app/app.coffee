window.VKNews = angular.module('vk-news', ['ngSanitize', 'vk_api'])

angular.module('vk-news').run ['Authentication', 'Browser', '$log', (Authentication, Browser, $log)->
  $log.info '## Application initialization'

  Browser.onInstalled.addListener (a) ->
    $log.info '## Processing onInstalled event'
    $log.info 'Reason:', a.reason
    $log.info 'Previous Version:', a.previousVersion

    Browser.alarms.create 'update_posts',
      when: Date.now() + 1000
      periodInMinutes: 1.0

  Browser.onMessage.addListener (request, sender, sendResponse) ->
    $log.info '## Processing onMessage event'
    $log.info 'Request:', request
    $log.info 'Sender:', sender

    if request.action is 'vk_notification_auth'
      Authentication.execute()

      sendResponse({content: "OK"})

    true

  Browser.alarms.onAlarm.addListener (alarm)->
    $log.info "## Execute onAlarm event `#{alarm.name}`"

    if alarm.name is 'update_posts'
      # TODO: here should go update post handler
      Browser.setBadgeValue(1)
]
