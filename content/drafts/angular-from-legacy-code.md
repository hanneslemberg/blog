---
title: Bridge angular and legacy code
tags: TIL, angular, snipptes
---

In directive/component
```javascript
...
function init() {
  $scope.$watchGroup(['vm.name', 'vm.email', 'vm.password'], function() {
      self.valuesChanged();
      loadSchedule(self.vehicleId);
  });
}
...
```

In Webpage:
```javascript
$(document).ready(function() {
   var injector = angular.bootstrap('#angularId', ['module'], {strictDi: true});
   var $timeout = injector.get('$timeout');
   var model = $('div[directiveName]>div').scope().vm;

   var ids = "#input_name, #input_email, #input_password";
   $(ids).on('keyup', update);

   update();

   function update() {
       $timeout(function() {
           model.name = $('#input_name').val();
           model.email = $('#input_email').val();
           model.password = $('#input_password').val();
       });
   }
});
```
