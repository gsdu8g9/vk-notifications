VKNews.filter 'groupLink', ->
  (input) ->
    input = input || '';

    "http://vk.com/#{input}"
