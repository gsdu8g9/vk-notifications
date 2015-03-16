function Post ($q, $filter, LocalStorage, SyncStorage, API, Group) {
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

    result = responses.map(function (responseChunk) {
      var posts = [],
          totalPostsCount = null;

      angular.forEach(responseChunk.data.response, function (response, index) {
        angular.forEach(response, function (item, index) {
          if (parseInt(index, 10) === 0) {
            totalPostsCount = item;
          } else {
            posts.push(item);
          }
        });

        var groupId = posts[posts.length - 1].to_id;
        groupPostsCount[groupId] = totalPostsCount;
      });

      return posts;
    }).reduce(function (a, b) {
      return a.concat(b);
    })

    result = $filter('orderBy')(result, 'date', true);

    console.log(groupPostsCount)

    return {
      posts: result,
      new_posts: newPosts
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

angular.module('vk-news').factory('Post', ['$q', '$filter', 'LocalStorage', 'SyncStorage', 'API', 'Group', Post])
