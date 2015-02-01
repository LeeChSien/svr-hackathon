(function() {
  var dishApp = angularApplication.module('dishApp',
    ['ngSanitize', 'ui.bootstrap', 'akoenig.deckgrid', 'cgNotify', 'ngDialog', 'ngTagsInput', 'infinite-scroll',
     'monospaced.elastic', 'ngUpload', 'validator', 'validator.rules.zh', 'angularMoment', 'ngWebSocket', 'ngAnimate']);

  dishApp.run(function(amMoment) {
    amMoment.changeLocale('zh-tw');
  });

  dishApp.controller('wallCtrl', ['$scope', function($scope) {
  }]);

  dishApp.controller('dishCtrl', ['$scope', '$http', function($scope, $http) {
    $scope.dish = null;
    $scope.like_status = {};

    $scope.init = function(dish) {
      if (dish && $scope.dish == null) {
        $scope.dish = angular.copy(dish, $scope.dish);
        $scope.like_status = $scope.dish.like_status;
/*
        $http.post('/dishes/' + $scope.dish.id + '/like', {
          action_type: 'status'
        }).success(function(content) {
          $scope.like_status = content;
        });
*/
      }
    };

    $scope.like_toggle = function() {
      if ($scope.like_status.liked) {
        $http.post('/dishes/' + $scope.dish.id + '/like', {
          action_type: 'dislike'
        }).success(function(content) {
          $scope.like_status = content;
        });
      } else {
        $http.post('/dishes/' + $scope.dish.id + '/like', {
          action_type: 'like'
        }).success(function(content) {
          $scope.like_status = content;
        });
      }
      $scope.like_status.liked = !$scope.like_status.liked;
    }
  }]);

  dishApp.controller('pageCtrl', ['$scope', '$modal', 'ngDialog', '$http',
  function($scope, $modal, ngDialog, $http) {
    $scope.openPostDish = function () {
      ngDialog.open({
        template: 'postDishModalContent.html',
        controller: 'postDishCtrl',
        closeByEscape: false,
        closeByDocument: false,
        showClose: false,
        scope: $scope
      });
    };

    $scope.openManageCollections = function(dish) {
      $scope.selected_dish = dish;
      ngDialog.open({
        template: 'manageCollectionsModalContent.html',
        controller: 'manageCollectionsCtrl',
        closeByEscape: false,
        closeByDocument: true,
        showClose: false,
        scope: $scope
      });
    };

    $scope.collections = Collections;
    $scope.selected_dish = [];

    $scope.page     = 1;
    $scope.visit_user = null;
    $scope.keywords = '';
    $scope.dishes   = [];

    $scope.busy = false;
    $scope.end = false;
    $scope.extra_query = ''

    $scope.nextPage = function() {
      if ($scope.busy || $scope.end)
        return;

      $scope.busy = true;

      $http.get('/dishes/list?page=' + $scope.page + $scope.extra_query).
      success(function(content) {
        $scope.dishes.push.apply($scope.dishes, content);
        $scope.page += 1;
        $scope.busy = false;

        if (content.length < 30)
          $scope.end = true;
      });
    };

    $scope.initIndex = function() {
      //
    };

    $scope.initVisit = function() {
      $scope.visit_user = User;
      $scope.extra_query = "&user_id=" + $scope.visit_user.id;
    };

    $scope.initShow = function() {
      $scope.dishes.push.apply($scope.dishes, [Dish]);
    };

    $scope.addCollection = function(content) {
      $scope.collections.push.apply($scope.collections, [content]);
    };


  }]);


  dishApp.controller('manageCollectionsCtrl', ['$scope', '$http', '$element',
  function($scope, $http, $element) {
    $scope.model = {collection: ''};

    $scope.close = function() {
      $scope.closeThisDialog();
    };

    $scope.submitCollection = function() {
      if ($scope.model.collection.length == 0)
        return;

      $http.post('/collections', {name: $scope.model.collection}).success(function(content) {
        $scope.addCollection(content);
      });

      $scope.model.collection = '';
    };

    $scope.isCollectionIncludeDish = function(collection, dish) {

      for (var i = 0; i < collection.dishes.length; i++) {
        if (collection.dishes[i].id == dish.id) {
          return true;
        }
      }
      return false;
    };

    $scope.toggle = function(collection_index, dish) {
      if ($scope.isCollectionIncludeDish($scope.collections[collection_index], dish)) {
        $scope.remove(collection_index, dish);
      } else {
        $scope.add(collection_index, dish);
        $scope.collections[collection_index].dishes.push();
      }
    };

    $scope.remove = function(collection_index, dish) {
      $http.post('/dishes/' + dish.id + '/remove_collection',
      {collection_id: $scope.collections[collection_index].id}).success(function(content) {
        $scope.collections[collection_index] = content;
      });
    };

    $scope.add = function(collection_index, dish) {
      $http.post('/dishes/' + dish.id + '/add_collection',
      {collection_id: $scope.collections[collection_index].id}).success(function(content) {
        $scope.collections[collection_index] = content;
      });
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
      $scope.dishes.unshift.apply($scope.dishes, [response]);

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

  dishApp.controller('commentDishCtrl', ['$scope', '$http', '$element', '$websocket', '$interval',
  function($scope, $http, $element, $websocket, $interval) {

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

      var time_now = Date.now();
      stream.send(JSON.stringify({
        m_type: 'comment',
        body: $scope.model.comment,
        created_at: time_now,
        user: CurrentUser
      }));

      $scope.model.comment = '';
    };

    var stream, ping;
    stream = $websocket('wss://' + ChatCluster.url + '/' + Dish.fingerprint);
    stream.onMessage(function(message) {
      m = JSON.parse(message.data);

      if (m.m_type == 'comment') {
        $scope.comments.push.apply($scope.comments, [m]);
      }
    });

    ping = $interval(function() {
      stream.send({m_type: 'ping'});
    }, 5000);


  }]);
})();
