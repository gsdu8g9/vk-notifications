`
//= require ../node_modules/jquery/dist/jquery.min.js
//= require api_manager.js
//= require helpers.js
`

groupItems = {}
accessToken = null

# Adds group-item to localstorage
#
addGroupItemToStroage = (item, fn) ->
  if item
    if fn and fn.success and typeof fn.success is "function"
      callback = fn.success
    else
      callback = ->

    item.gid = "-#{item.gid}"

    groupItems[item.gid] = item
    chrome.storage.local.set {'group_items': groupItems}, callback
  else
    if fn and fn.error and typeof fn.error is "function"
      fn.error 'item is undefined'


# Removes group-item from localstorage
#
removeGroupItemFromStorage = (gid, fn) ->
  if gid
    if fn and fn.success and typeof fn.success is "function"
      callback = fn.success
    else
      callback = ->

    delete groupItems[gid]

    chrome.storage.local.set {'group_items': groupItems}, callback
  else
    if fn and fn.error and typeof fn.error is "function"
      fn.error 'item is undefined'


# Event handler to remove group-item from storage
#
$(document).on 'click', 'button[name=removeGroupItem]', (e) ->
  $self = $(this)
  removeGroupItemFromStorage $(this).data('group'), success: ->
    $self.parent().remove()
  e.preventDefault()


# Bind on 'enter' key pressed event listener for pageUrl input field
#
# Tries to save information about group to localstorage
#
$(document).on 'keypress', 'input[name=pageUrl]', (e) ->
  if e.which is 13
    $(this).parent().find('button[name=saveGroupItem]').click()


$ ->

  # Remove all group-items from local storage
  #
  $('#clean-items').click (e) ->
    chrome.storage.local.remove 'group_items', ->
      groups = []


  # Auth button click listener
  #
  # Sends message to background script to run 'vk_notification_auth' action
  #
  $('#auth').click (e) ->
    chrome.runtime.sendMessage {action: "vk_notification_auth"}, (response) ->
      if response.content is 'OK'
        $('.auth-actions').hide()
        $('.option-items, #add-item').show()

    e.preventDefault()


  # Show auth button if user is not authorized
  #
  chrome.storage.local.get 'vkaccess_token': {}, (items) ->
    if items.vkaccess_token.length is undefined
      $('.auth-actions').show()
      $('.option-items, #add-item').hide()
      return
    else
      accessToken = items.vkaccess_token


  # Get group-items from local storage
  #
  chrome.storage.local.get 'group_items': {}, (items) ->
    groupItems = items.group_items

    for key, item of groupItems
      $parent = $('<div />', {class: 'item'})
      $('.option-items').append($parent)

      drawGroupItem($parent, item)

#      TODO: make update of information about group on opening options page
#
#      API.call 'groups.getById', {gid: key}, (data) ->
#        unless data.error

