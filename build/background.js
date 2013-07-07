// Generated by CoffeeScript 1.6.3
(function() {
  var badgeText, displayAnError, getUrlParameterValue, groupPosts, listenerHandler, loadByUrl, newPostsCount, postsCount, processPosts, processSingleRequest, prosessArrayOfRequests, totalNewPosts, updatePosts;

  groupPosts = [];

  postsCount = {};

  newPostsCount = {};

  totalNewPosts = 0;

  badgeText = function(number) {
    if (number <= 0) {
      return '';
    }
    if (number > 10) {
      return '10+';
    }
    return "" + number;
  };

  updatePosts = function(fn) {
    var callback;
    if (fn && typeof fn === 'function') {
      callback = fn;
    } else {
      callback = function() {};
    }
    return chrome.storage.local.get({
      'vkaccess_token': {}
    }, function(items) {
      var token;
      token = items.vkaccess_token;
      if (token.length !== void 0) {
        return chrome.storage.local.get({
          'group_items': {}
        }, function(items) {
          var item, key, requestPromisses, _ref;
          if (!$.isEmptyObject(items.group_items)) {
            requestPromisses = [];
            _ref = items.group_items;
            for (key in _ref) {
              item = _ref[key];
              requestPromisses.push(loadByUrl(API.requestUrl('wall.get', {
                owner_id: key,
                count: 10,
                access_token: token
              })));
            }
            return $.when.all(requestPromisses).then(function(schemas) {
              return processPosts(schemas, callback);
            });
          }
        });
      }
    });
  };

  loadByUrl = function(url) {
    return $.ajax({
      url: url,
      dataType: 'json'
    });
  };

  processSingleRequest = function(posts) {
    var groupId;
    groupId = posts[0].response[1].to_id;
    if (postsCount[groupId] === void 0) {
      totalNewPosts += 10;
    } else {
      if (!(posts[0].response[0] - postsCount[groupId] < 0)) {
        totalNewPosts = posts[0].response[0] - postsCount[groupId];
      }
    }
    if (posts[0].response[0] !== 0) {
      newPostsCount[groupId] = posts[0].response[0];
    }
    return _.rest(posts[0].response);
  };

  prosessArrayOfRequests = function(posts) {
    var result;
    result = _.flatten(_.map(posts, function(requests) {
      return processSingleRequest(requests);
    }));
    return result;
  };

  processPosts = function(posts, fn) {
    var responses;
    newPostsCount = {};
    if ($.isArray(posts[0])) {
      responses = prosessArrayOfRequests(posts);
    } else {
      responses = processSingleRequest(posts);
    }
    postsCount = newPostsCount;
    chrome.storage.local.set({
      'posts_count': postsCount
    });
    posts = _.sortBy(responses, function(item) {
      return -item.date;
    });
    if (fn && typeof fn === "function") {
      return fn(posts, totalNewPosts);
    }
  };

  displayAnError = function(textToShow, errorToShow) {
    return alert(textToShow + '\n' + errorToShow);
  };

  getUrlParameterValue = function(url, parameterName) {
    var param, parameterValue, temp, urlParameters, _i, _len;
    urlParameters = url.substr(url.indexOf("#") + 1);
    parameterValue = "";
    urlParameters = urlParameters.split("&");
    for (_i = 0, _len = urlParameters.length; _i < _len; _i++) {
      param = urlParameters[_i];
      temp = param.split("=");
      if (temp[0] === parameterName) {
        return temp[1];
      }
    }
    return parameterValue;
  };

  listenerHandler = function(authenticationTabId) {
    var tabUpdateListener;
    return tabUpdateListener = function(tabId, changeInfo) {
      var vkAccessToken, vkAccessTokenExpiredFlag;
      if (tabId === authenticationTabId && changeInfo.url !== void 0 && changeInfo.status === "loading") {
        if (changeInfo.url.indexOf('oauth.vk.com/blank.html') > -1) {
          authenticationTabId = null;
          chrome.tabs.onUpdated.removeListener(tabUpdateListener);
          vkAccessToken = getUrlParameterValue(changeInfo.url, 'access_token');
          if (vkAccessToken === void 0 || vkAccessToken.length === void 0) {
            displayAnError('vk auth response problem', 'access_token length = 0 or vkAccessToken == undefined');
            return;
          }
          vkAccessTokenExpiredFlag = Number(getUrlParameterValue(changeInfo.url, 'expires_in'));
          if (vkAccessTokenExpiredFlag !== 0) {
            displayAnError('vk auth response problem', 'vkAccessTokenExpiredFlag != 0' + vkAccessToken);
            return;
          }
          return chrome.storage.local.set({
            'vkaccess_token': vkAccessToken
          }, function() {
            return chrome.tabs.remove(tabId);
          });
        }
      }
    };
  };

  chrome.alarms.onAlarm.addListener(function(alarm) {
    if (alarm.name === 'update_posts') {
      return updatePosts(function(posts, totalNewPosts) {
        chrome.browserAction.setBadgeText({
          text: badgeText(totalNewPosts)
        });
        return groupPosts = posts;
      });
    }
  });

  chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
    var optionsUrl, vkAuthenticationUrl, vkClientId, vkRequestedScopes;
    if (request.action === "vk_notification_auth") {
      vkClientId = '3696318';
      vkRequestedScopes = 'wall,offline';
      vkAuthenticationUrl = "https://oauth.vk.com/authorize?client_id=" + vkClientId + "&scope=" + vkRequestedScopes + "&redirect_uri=http%3A%2F%2Foauth.vk.com%2Fblank.html&display=page&response_type=token";
      chrome.tabs.create({
        url: vkAuthenticationUrl,
        selected: true
      }, function(tab) {
        return chrome.tabs.onUpdated.addListener(listenerHandler(tab.id));
      });
      sendResponse({
        content: "OK"
      });
    }
    if (request.action === "noification_list") {
      chrome.storage.local.get({
        'group_items': {}
      }, function(items) {
        if (!$.isEmptyObject(items.group_items)) {
          if (groupPosts.length === 0) {
            return updatePosts(function(posts, number) {
              return sendResponse({
                content: 'OK',
                data: posts,
                groups: items.group_items
              });
            });
          } else {
            return sendResponse({
              content: 'OK',
              data: groupPosts,
              groups: items.group_items
            });
          }
        } else {
          return sendResponse({
            content: 'EMPTY_GROUP_ITEMS'
          });
        }
      });
    }
    if (request.action === "open_options_page") {
      optionsUrl = chrome.extension.getURL('options.html');
      chrome.tabs.query({
        url: optionsUrl
      }, function(tabs) {
        if (tabs.length) {
          return chrome.tabs.update(tabs[0].id, {
            active: true
          });
        } else {
          return chrome.tabs.create({
            url: optionsUrl
          });
        }
      });
      sendResponse({
        content: 'OK'
      });
    }
    if (request.action === "watch_post") {
      if (request.read === 'ALL') {
        totalNewPosts = 0;
      } else {

      }
      sendResponse({
        content: 'OK'
      });
    }
    return true;
  });

  chrome.runtime.onInstalled.addListener(function() {
    return chrome.storage.local.get({
      'posts_count': {}
    }, function(items) {
      postsCount = items.posts_count;
      return chrome.alarms.create("update_posts", {
        when: Date.now() + 1000,
        periodInMinutes: 1.0
      });
    });
  });

}).call(this);
