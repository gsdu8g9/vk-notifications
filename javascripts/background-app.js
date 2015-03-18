//= require app

var backgroundApp = angular.module('vk-news-background', ['vk-news']);

function onRun (Authentication, Browser, Post, $log) {
  $log.info('## Application initialization');

  Browser.onInstalled.addListener(function (a) {
    $log.info('## Processing onInstalled event')
    $log.info('Reason:', a.reason)
    $log.info('Previous Version:', a.previousVersion)

    Browser.alarms.create('update_posts', {
      when: Date.now() + 1000,
      periodInMinutes: 1.0
    })
  });

  Browser.onMessage.addListener(function (request, sender, sendResponse) {
    $log.info('## Processing onMessage event')
    $log.info('Request:', request)
    $log.info('Sender:', sender)

    if (request.action === 'vk_notification_auth') {
      Authentication.execute();

      return sendResponse({content: "OK"})
    }

    // if request.action is 'update_posts'
    //   BackgroundJob.updatePosts().then (result) ->
    //     sendResponse({content: 'OK', result: result})

    if (request.action === 'open_options_page') {
      optionsUrl = chrome.extension.getURL('options.html');

      chrome.tabs.query({ url: optionsUrl }, function (tabs) {
        if (tabs.length) {
          chrome.tabs.update(tabs[0].id, { active: true });
        } else {
          chrome.tabs.create({ url: optionsUrl });
        }
      })

      return sendResponse({content: 'OK'})
    }

    if (request.action === "watch_post") {
      if (request.read === 'ALL') {
        totalNewPosts = 0;
        chrome.browserAction.setBadgeText({text: badgeText(totalNewPosts)});
      } else {
        // TODO: open tab with the clicked post
        // chrome.tabs.query url: optionsUrl, (tabs)->
        //   if tabs.length
        //     chrome.tabs.update tabs[0].id, active: true
        //   else
        //     chrome.tabs.create url: optionsUrl
      }

      return sendResponse({content: 'OK'})
    }

    if (request.action === 'clean_up') {
      chrome.storage.local.remove('posts_count');
      postsCount = {};

      console.log('on clean_up - postsCount', postsCount)

      return sendResponse({content: 'OK'})
    }

    return true
  });

  Browser.alarms.onAlarm.addListener(function (alarm) {
    $log.info("## Execute onAlarm event `#{alarm.name}`");

    if (alarm.name === 'update_posts') {
      Post.query().then(function (posts) {
        newPosts = posts.posts_count;
        Browser.setBadgeValue(newPosts);
      })
    }
  });
}

backgroundApp.run(['Authentication', 'Browser', 'Post', '$log', onRun])
