(function() {
  var accessToken, addGroupItemToStroage, groupItems, removeGroupItemFromStorage;

  groupItems = {};

  accessToken = null;

  addGroupItemToStroage = function(item, fn) {
    var callback;
    if (item) {
      if (fn && fn.success && typeof fn.success === "function") {
        callback = fn.success;
      } else {
        callback = function() {};
      }
      item.gid = "-" + item.gid;
      groupItems[item.gid] = item;
      return chrome.storage.local.set({
        'group_items': groupItems
      }, callback);
    } else {
      if (fn && fn.error && typeof fn.error === "function") {
        return fn.error('item is undefined');
      }
    }
  };

  removeGroupItemFromStorage = function(gid, fn) {
    var callback;
    if (gid) {
      if (fn && fn.success && typeof fn.success === "function") {
        callback = fn.success;
      } else {
        callback = function() {};
      }
      delete groupItems[gid];
      return chrome.storage.local.set({
        'group_items': groupItems
      }, callback);
    } else {
      if (fn && fn.error && typeof fn.error === "function") {
        return fn.error('item is undefined');
      }
    }
  };

  $(document).on('click', 'button[name=removeGroupItem]', function(e) {
    var $self;
    $self = $(this);
    removeGroupItemFromStorage($(this).data('group'), {
      success: function() {
        return $self.parent().remove();
      }
    });
    return e.preventDefault();
  });

  $(document).on('keypress', 'input[name=pageUrl]', function(e) {
    if (e.which === 13) {
      return $(this).parent().find('button[name=saveGroupItem]').click();
    }
  });

  $(function() {
    $('#clean-items').click(function(e) {
      return chrome.storage.local.remove('group_items', function() {
        var groups;
        return groups = [];
      });
    });
    chrome.storage.local.get({
      'vkaccess_token': {}
    }, function(items) {
      if (items.vkaccess_token.length === void 0) {
        $('.auth-actions').show();
        $('.option-items, #add-item').hide();
      } else {
        return accessToken = items.vkaccess_token;
      }
    });
    return chrome.storage.local.get({
      'group_items': {}
    }, function(items) {
      var $parent, item, key, _results;
      groupItems = items.group_items;
      _results = [];
      for (key in groupItems) {
        item = groupItems[key];
        $parent = $('<div />', {
          "class": 'item'
        });
        $('.option-items').append($parent);
        _results.push(drawGroupItem($parent, item));
      }
      return _results;
    });
  });

}).call(this);
