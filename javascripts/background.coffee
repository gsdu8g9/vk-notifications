`
//= require ../bower_components/jquery/dist/jquery.min.js
//= require ../bower_components/underscore/underscore.js
//= require api_manager.js
//= require helpers.js
`

groupPosts = []

postsCount = {}

# The variable is used for storing the new value of postsCount
#
# Finally the content should be sent to postsCount variable

newPostsCount = {}


totalNewPosts = 0

# Return a promise
#
# @param  {string} url  Request path
#
# @return {function} $.ajax function for specified request path

loadByUrl = (url) ->
  return $.ajax
    url: url
    dataType: 'json'


processSingleRequest = (posts) ->

  console.log('processSingleRequest - posts', posts)

  # If the group doesn't have any posts than posts[0].response[1] will be undefuned
  # and calling to_id will caouse the error
  groupId = posts[0].response[1].to_id unless posts[0].response[1] is undefined

  console.log('processSingleRequest - groupId', groupId)

  # if the new group was added
  if postsCount[groupId] is undefined

    console.log('processSingleRequest - when postsCount[groupId] is undefined - totalNewPosts', totalNewPosts)

    # All posts from that group are new
    # Unless the group is undefined
    totalNewPosts += 10 unless groupId is undefined
  else

    console.log('processSingleRequest - when postsCount[groupId] is not undefined - posts[0].response[0]', posts[0].response[0])
    console.log('processSingleRequest - when postsCount[groupId] is not undefined - postsCount[groupId]', postsCount[groupId])

    unless posts[0].response[0] - postsCount[groupId] < 0
      totalNewPosts += posts[0].response[0] - postsCount[groupId]

    console.log('processSingleRequest - when postsCount[groupId] is not undefined - totalNewPosts', totalNewPosts)

  console.log('processSingleRequest - totalNewPosts', totalNewPosts)

  # store the number of total posts in that group
  newPostsCount[groupId] = posts[0].response[0] unless posts[0].response[0] is 0

  return _.rest(posts[0].response)


prosessArrayOfRequests = (posts) ->

  console.log('prosessArrayOfRequests - posts', posts)

  result = _.flatten(
    _.map posts, (requests) ->
      return processSingleRequest(requests)
  )
  return result


processPosts = (posts, fn) ->

  console.log('processPosts - posts', posts)
  console.log('processPosts - postsCount', postsCount)

  newPostsCount = {}

  if $.isArray(posts[0])
    responses = prosessArrayOfRequests(posts)
  else
    responses = processSingleRequest(posts)

  console.log('processPosts - responses', responses)

  postsCount = newPostsCount

  console.log('processPosts - postsCount', postsCount)

  # Save new value of postsCount to localstorage
  chrome.storage.local.set {'posts_count': postsCount}

  posts = _.sortBy responses, (item) -> return -item.date

  console.log('processPosts - posts', posts)
  console.log('processPosts - totalNewPosts', totalNewPosts)

  if fn and typeof fn is "function"
    fn(posts, totalNewPosts)
