VKNews.factory 'Post', ['$q', 'LocalStorage', 'SyncStorage', 'API', ($q, LocalStorage, SyncStorage, API) ->
  query: (token)->
    deferred = $q.defer()

    formatQueryResult = (values)->
      if values.length is 0
        result = values
        new_posts = 0
      else
        result = values.map((item) ->
          response = item.data.response
          totalPostsCount = null
          posts = []

          for index, item of response
            if parseInt(index, 10) is 0
              totalPostsCount = item
            else
              posts.push item

          posts
        ).reduce (a, b) ->
          a.concat(b)

        new_posts = 0

      {
        posts: result,
        new_posts: new_posts
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
