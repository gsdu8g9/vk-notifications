BackgroundJob = ($q, $log, LocalStorage, SyncStorage) ->
  updatePosts: ->
    Post.query().then (posts) ->


angular.module('vk-news').factory 'BackgroundJob', [
  '$q', '$log', 'LocalStorage', 'SyncStorage', BackgroundJob
]
