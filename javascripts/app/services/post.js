function Post ($q, LocalStorage, SyncStorage, API, Group) {
  function emptyResult () {
    return {
      posts: [],
      new_posts: {}
    }
  }

  function formatQueryResult (responses) {
    var result, newPosts;

    if (responses.length === 0) {
      return emptyResult();
    }

    var groupPostsCount = {};

    result = responses.map(function (response) {
      var response = response.data.response[0],
          posts = [],
          totalPostsCount = null;

      angular.forEach(response, function (item, index) {
        if (parseInt(index, 10) === 0) {
          totalPostsCount = item;
        } else {
          posts.push(item);
        }
      });

      var groupId = posts[posts.length - 1].to_id
      groupPostsCount[groupId] = totalPostsCount

      return posts;
    }).reduce(function (a, b) {
      return a.concat(b);
    })

    console.log(groupPostsCount)

    return {
      posts: result,
      new_posts: newPosts
    }
  }

  return {
    query: function (token) {
      var deferred = $q.defer();

      if (token) {
        var storagePromise = SyncStorage.getValue('group_ids');
        storagePromise.then(function (groupIds) {
          var promises = [];

          // Maximum API request number in stored functions on VK API
          var chunkSize = 25;
          for (var i = 0, j = groupIds.length; i < j; i += chunkSize) {
            var groupIdsChunk = groupIds.slice(i, i + chunkSize);
            promises.push(API.call('execute.getPosts', {group_ids: groupIdsChunk.join(','), access_token: token}));
          }

          $q.all(promises).then(function (result) {
            deferred.resolve(formatQueryResult(result));
          });
        });
      } else {
        deferred.resolve(emptyResult());
      }

      return deferred.promise;
    }
  }
}

angular.module('vk-news').factory('Post', ['$q', 'LocalStorage', 'SyncStorage', 'API', 'Group', Post])
