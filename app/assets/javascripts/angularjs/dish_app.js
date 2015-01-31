(function() {
  var dishApp = angularApplication.module('dishApp',
    ['ngSanitize', 'ui.bootstrap', 'akoenig.deckgrid', 'cgNotify', 'ngDialog', 'ngTagsInput',
     'monospaced.elastic', 'ngUpload', 'validator', 'validator.rules.zh', 'angularMoment']);

  dishApp.run(function(amMoment) {
    amMoment.changeLocale('zh-tw');
  });

  dishApp.controller('wallCtrl', ['$scope', function($scope) {
  }]);

  dishApp.controller('pageCtrl', ['$scope', '$modal', 'ngDialog', '$http',
  function($scope, $modal, ngDialog, $http) {
    $scope.openPostDish = function () {
      ngDialog.open({
        template: 'postDishModalContent.html',
        controller: 'postDishCtrl',
        closeByEscape: false,
        closeByDocument: false,
        showClose: false
      });
    };

    $scope.page     = 1;
    $scope.keywords = '';
    $scope.dishes   =[]

    $http.get('/dishes/list').success(function(content) {
      $scope.dishes.push.apply($scope.dishes, content);
    });
  }]);

  dishApp.controller('ModalInstanceCtrl', ['$scope', '$modalInstance',
  function ($scope, $modalInstance) {
    $scope.cancel = function () {
      $modalInstance.dismiss('cancel');
    };
  }]);

  dishApp.controller('postDishCtrl', ['$scope', '$validator', '$element', 'notify',
  function($scope, $validator, $element, notify) {
    notify.config({
      classes:'alert-success',
      duration: 3000
    });

    $scope.model = {};
    $scope.preview_image = null;
    $scope.busy = false;

    $scope.submit = function() {
      if (!$scope.preview_image) {
        $scope.image_empty = true;
        return;
      }

      $validator.validate($scope, 'model').success(function() {
        $scope.model['tag_list'] = $scope.model['tags'].map(function(t) {return t.text;}).join(',');
        $scope.busy = true;
        $element.find('form').submit();
      }).error(function() {
        //
      });
    };

    $scope.close = function() {
      $scope.closeThisDialog();
    };

    $scope.uploadComplete = function(response) {
      $scope.closeThisDialog();
      notify({ message:'上傳成功!'});
    };

    $element.find('input[type=file]').on('change', function(evt) {
      $scope.preview_image = null;

      var file = ((evt.dataTransfer !== undefined) ? evt.dataTransfer.files[0] : evt.target.files[0]);
      if (!file.type.match(/image.*/))
        return;

      var reader = new FileReader();
      reader.onload = (function(theFile) {
        return function(e) {
          $scope.$apply(function() {
            $scope.preview_image = e.target.result;
          });
        };
      })(file);
      reader.readAsDataURL(file);
    });
  }]);

  dishApp.controller('commentDishCtrl', ['$scope', '$http', '$element', 'notify',
  function($scope, $http, $element, notify) {

    $scope.comments = [];
    $scope.model = {comment: ''};
    $scope.loaded = false;

    $http.get('/dishes/' + Dish.id + '/comments').success(function(content) {
      $scope.loaded = true;
      $scope.comments.push.apply($scope.comments, content);
    });

    $scope.submitComment = function() {
      if ($scope.model.comment.length == 0)
        return;

      $http.post('/dishes/' + Dish.id + '/comment', {
        body: $scope.model.comment
      }).success(function(content) {

      });

      $scope.model.comment = '';
    };
  }]);
})();
