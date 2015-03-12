`
//= require ../bower_components/jquery/dist/jquery.min.js
`

showAttachments = (attachments) ->
  return null unless attachments

  photos = $('<div />', class: 'photos')
  links = $('<div />', class: 'links')

  for attachment in attachments
    photos.append($('<img />', src: attachment.photo.src, class: 'photo')) if attachment.type is "photo"
    links.append($('<a />', href: attachment.link.url, text: attachment.link.url, class: 'link')) if attachment.type is "link"

  $('<div />', class: 'attachments').append(photos).append(links)

# $ ->
  # chrome.storage.local.get 'vkaccess_token': {}, (items) ->
  #   chrome.runtime.sendMessage {action: "noification_list", token: items.vkaccess_token}, (response) ->
  #     if response.content is 'EMPTY_GROUP_ITEMS'
  #       'no groups'
  #     else
  #       for item in response.data
  #         $('#notifications').append(itemTemplate(item, response.groups));
