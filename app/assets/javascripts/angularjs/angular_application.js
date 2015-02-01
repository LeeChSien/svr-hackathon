var angularApplication = (function() {

  function set_rails_csrf(app) {
    app.config(function($httpProvider) {
      $httpProvider.defaults.headers.common['X-CSRF-Token'] =
      $('meta[name=csrf-token]').attr('content');
    });
  }

  return {
    module: function(name, modules) {
      var new_app = angular.module(name, modules);

      set_rails_csrf(new_app);

      new_app.directive('bootstrapFileInput', function() {
        return {
          restrict: 'AC',
          link: function(scope, element, attrs) {
            $(element).bootstrapFileInput();
          }
        };
      });

      new_app.controller('searchFormCtrl', ['$scope', '$element', '$http',
      function($scope, $element, $http) {
        $scope.keyword = '';
        if (typeof Keyword !== 'undefined')
          $scope.keyword = Keyword;

        $scope.submit = function() {
          if ($scope.keyword.length > 0)
            $element.submit();
        };

        $scope.searchTag = function(tag) {
          $scope.keyword = tag;
          window.location = '/dishes/search?keyword=' + tag;
        };
      }]);

      return new_app;
    }
  };
})();
