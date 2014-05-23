groupItems = {}
accessToken = null

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

#      TODO: make update of information about group on opening options page
#
#      API.call 'groups.getById', {gid: key}, (data) ->
#        unless data.error

