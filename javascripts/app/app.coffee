# Returns a badge text according to number of posts
#
badgeText = (number) ->
  return '' if number <= 0 or number is undefined
  return '10+' if number > 10
  "#{number}"

window.VKNews = angular.module('vk-news', ['ngSanitize', 'vk_api'])

angular.module('vk-news').run ->
  console.log 'Application initialization'

  chrome.runtime.onInstalled.addListener (r)->
    console.log 'Processing onInstalled event'
    console.log r
    chrome.alarms.create "update_posts",
      when: Date.now() + 1000
      periodInMinutes: 1.0

  chrome.storage.local.get 'posts_count': {}, (items) ->
    postsCount = items.posts_count

    console.log('onLaunch - postsCount', postsCount)

    chrome.browserAction.setBadgeText({text: badgeText(7)})
