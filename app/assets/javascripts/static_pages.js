angular.module("app", [])
.controller("urlsController", function ($scope, $http) {
  $scope.urls = {};
  var url="/top_urls";

  $http.get(url).success(function(response) {
    $scope.urls = response; 
  });

})
.controller("referrersController", function ($scope, $http) {
  $scope.urls = {};
  var url="/top_referrers";

  $http.get(url).success(function(response) {
    $scope.referrers = response; 
  });
});
