angular.module("ironDirectory", []).

controller("staffController", ["$scope", "$http", function($scope, $http) {
  $scope.sort    = "last_name"
  $scope.reverse = false
  $scope.filter  = ""

  $scope.title_for = function(member) {
    if (member.current_course) {
      return member.current_course.topic
    } else {
      return member.title
    }
  }

  $scope.toggleSort = function(field) {
    if ($scope.sort == field) {
      $scope.reverse = !$scope.reverse
    } else {
      $scope.sort = field
      $scope.reverse = false
    }
  }

  $http.get(window.location + ".json").success(function(data) {
    $scope.members = data.staff
  })
}])
