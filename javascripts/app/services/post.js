function Post ($q, $filter, LocalStorage, SyncStorage, API) {
  function emptyResult () {
    return {
      posts: [],
      posts_count: {}
    }
  }

  function formatQueryResult (responses) {
    var result;
    var groupPostsCount = {};

    if (responses.length === 0) {
      return emptyResult();
    }

    result = responses.map(function (responseChunk) {
      var posts = [],
          totalPostsCount = null;

      angular.forEach(responseChunk.data.response, function (response, index) {
        var data = response;

        totalPostsCount = data.splice(0, 1);
        posts = posts.concat(data);

        var groupId = posts[posts.length - 1].to_id;
        groupPostsCount[groupId] = totalPostsCount;
      });

      return posts;
    }).reduce(function (a, b) {
      return a.concat(b);
    })

    result = $filter('orderBy')(result, 'date', true);

    return {
      posts: result,
      posts_count: groupPostsCount
    }
  }

  return {
    query: function (accessToken) {
      var deferred = $q.defer();

      if (accessToken) {
        var storagePromise = SyncStorage.getValue('group_ids');
        storagePromise.then(function (groupIds) {
          var promises = [];

          // Maximum API request number in stored functions on VK API
          var chunkSize = 25;
          for (var i = 0, j = groupIds.length; i < j; i += chunkSize) {
            var groupIdsChunk = groupIds.slice(i, i + chunkSize);
            promises.push(API.call('execute.getPosts', {group_ids: groupIdsChunk.join(','), access_token: accessToken}));
          }

          $q.all(promises).then(function (result) {
            result = formatQueryResult(result)

            deferred.resolve(result);
          });
        });
      } else {
        deferred.resolve(emptyResult());
      }

      return deferred.promise;
    }
  }
}

angular.module('vk-news').factory('Post', ['$q', '$filter', 'LocalStorage', 'SyncStorage', 'API', Post])
