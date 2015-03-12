VKNews.factory 'Post', ['$q', 'LocalStorage', 'SyncStorage', 'API', 'Group', ($q, LocalStorage, SyncStorage, API, Group) ->
  query: (token)->
    deferred = $q.defer()

    formatQueryResult = (values)->
      if values.length is 0
        result = values
        newPosts = {}
      else
        groupPostsCount = {}

        result = values.map((item) ->
          response = item.data.response
          posts = []
          totalPostsCount = null

          for index, item of response
            if parseInt(index, 10) is 0
              totalPostsCount = item
            else
              posts.push item

          groupId = posts[posts.length - 1].to_id
          groupPostsCount[groupId] = totalPostsCount

          posts
        ).reduce (a, b) ->
          a.concat(b)

        console.log groupPostsCount
      {
        posts: result,
        new_posts: newPosts
      }

    if token
      storagePromise = SyncStorage.getValue('group_ids')
      storagePromise.then (groupIds)->
        promises = []
        for key, item of groupIds
          promises.push API.call('wall.get', {owner_id: item, count: 10, access_token: token})

        $q.all(promises).then (result)->
          deferred.resolve formatQueryResult(result)
    else
      deferred.resolve formatQueryResult([])

    deferred.promise
]
