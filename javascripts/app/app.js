var app = angular.module('vk-news', ['ngSanitize', 'vk_api']);

app.config(['$compileProvider', function ($compileProvider) {
  $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|file|tel|chrome-extension):/);
}]);
