(function() {
  var collectionApp = angularApplication.module('collectionApp',
    ['ngSanitize', 'ui.bootstrap', 'akoenig.deckgrid', 'cgNotify', 'ngDialog', 'ngTagsInput', 'cgPrompt',
     'monospaced.elastic', 'ngUpload', 'validator', 'validator.rules.zh', 'angularMoment', 'ngWebSocket', 'ngAnimate', 'ngDragDrop']);

  collectionApp.controller('pageCtrl', ['$scope', 'prompt', '$http', function($scope, prompt, $http) {
    $scope.collections = Collections;

    $scope.remove = function(index) {
      prompt({
        title: '是否刪除收藏列表？',
        message: '確定刪除？',
        buttons: [{ label:'取消', cancel: true }, { label:'確定', primary: true, style: 'btn-danger'}]
      }).then(function(){
        $http.delete('/collections/' + $scope.collections[index].id).success(function() {
          //
        });

        $scope.collections.splice (index, 1);
      });
    }
  }]);
})();
