window.VKNews = angular.module('vk-news', ['ngSanitize', 'vk_api'])

angular.module('vk-news').run ['Authentication', 'Browser', 'Post', '$log', (Authentication, Browser, Post, $log)->
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

    if request.action is 'open_options_page'
      optionsUrl = chrome.extension.getURL('options.html')

      chrome.tabs.query url: optionsUrl, (tabs)->
        if tabs.length
          chrome.tabs.update tabs[0].id, active: true
        else
          chrome.tabs.create url: optionsUrl

      sendResponse({content: 'OK'})

    if request.action is "watch_post"
      if request.read is 'ALL'
        totalNewPosts = 0
        chrome.browserAction.setBadgeText({text: badgeText(totalNewPosts)})
      else
  #      TODO: open tab with the clicked post
  #      chrome.tabs.query url: optionsUrl, (tabs)->
  #        if tabs.length
  #          chrome.tabs.update tabs[0].id, active: true
  #        else
  #          chrome.tabs.create url: optionsUrl

      sendResponse({content: 'OK'})

    if request.action is 'clean_up'
      chrome.storage.local.remove 'posts_count'
      postsCount = {}

      console.log('on clean_up - postsCount', postsCount)

      sendResponse({content: 'OK'})

    true

  Browser.alarms.onAlarm.addListener (alarm)->
    $log.info "## Execute onAlarm event `#{alarm.name}`"

    if alarm.name is 'update_posts'
      Post.query().then (posts) ->
        newPosts = posts.new_posts
        Browser.setBadgeValue(newPosts)
]
