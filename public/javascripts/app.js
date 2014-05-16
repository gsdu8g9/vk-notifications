(function() {
  var OptionsCtrl;

  window.VKNews = angular.module('vk-news', []);

  VKNews.factory('Authorization', [
    '$q', function($q) {
      return {
        authenticate: function() {
          var deferred;
          deferred = $q.defer();
          chrome.runtime.sendMessage({
            action: "vk_notification_auth"
          }, (function(_this) {
            return function(response) {
              if (response.content === 'OK') {
                return _this.getAccessToken().then(function(result) {
                  return deferred.resolve({
                    status: true,
                    access_token: result
                  });
                });
              } else {
                return deferred.resolve({
                  status: false
                });
              }
            };
          })(this));
          return deferred.promise;
        },
        setAccessToken: function(token) {},
        getAccessToken: function() {
          var deferred;
          deferred = $q.defer();
          chrome.storage.local.get({
            'vkaccess_token': null
          }, function(items) {
            return deferred.resolve(items.vkaccess_token);
          });
          return deferred.promise;
        }
      };
    }
  ]);

  VKNews.factory('API', [
    '$http', function($http) {
      return {
        call: function(method, options, callback) {
          return $http({
            method: 'GET',
            url: this.requestUrl(method),
            params: options
          }).success(callback).error(callback);
        },
        requestUrl: function(method) {
          return "https://api.vk.com/method/" + method.toString();
        }
      };
    }
  ]);

  OptionsCtrl = function($scope, $rootScope, API, Authorization) {
    $scope.pageUrl = '';
    $scope.isItemFormShowed = false;
    $scope.isSaving = false;
    $scope.hasError = false;
    $scope.errorMessage = '';
    $scope.groups = [];
    Authorization.getAccessToken().then(function(result) {
      return $scope.accessToken = result;
    });
    $scope.authenticate = function() {
      return Authorization.authenticate().then(function(result) {
        if (result.status) {
          return $scope.accessToken = result.accessToken;
        }
      });
    };
    $scope.showItemForm = function() {
      $scope.pageUrl = '';
      return $scope.isItemFormShowed = true;
    };
    return $scope.saveGroupItem = function() {
      var eventMatch, shortName, url;
      $scope.isSaving = true;
      $scope.hasError = false;
      url = $scope.pageUrl;
      shortName = url.match(/vk.com\/(\w+)/);
      if (!shortName) {
        $scope.hasError = 'Неверный формат ссылки';
        $scope.isSaving = false;
        return;
      }
      eventMatch = shortName[1].match(/event(\d+)/);
      if (eventMatch) {
        shortName = eventMatch;
      }
      API.call('groups.getById', {
        group_ids: shortName[1],
        access_token: $scope.accessToken
      }, function(data) {
        console.log(data);
        if (!data.error) {
          console.log('save item here');
          return $scope.groups.push(data.response[0]);
        } else {
          $scope.hasError = 'Группа не найдена';
          $scope.isSaving = false;
        }
      });
      return $scope.isSaving = false;
    };
  };

  VKNews.controller('OptionsCtrl', ['$scope', '$rootScope', 'API', 'Authorization', OptionsCtrl]);

}).call(this);
