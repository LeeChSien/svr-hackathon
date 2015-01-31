(function() {
  var deviseApp = angularApplication.module('deviseApp',
  ['ngSanitize', 'ui.bootstrap', 'ngUpload', 'validator', 'validator.rules.zh']);

  deviseApp.controller('signInFormCtrl', ['$scope', '$validator', '$element',
  function($scope, $validator, $element) {
    $scope.model = {};

    $scope.submit = function() {
      $validator.validate($scope, 'model').success(function() {
        $element.submit();
      }).error(function() {
        //
      });
    }
  }]);

  deviseApp.controller('signUpFormCtrl', ['$scope', '$validator', '$element',
  function($scope, $validator, $element) {
    $scope.model = {};

    $scope.submit = function() {
      $validator.validate($scope, 'model').success(function() {
        $element.submit();
      }).error(function() {
        //
      });
    }
  }]);
})();
