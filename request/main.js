angular.module('demoApp', ['ngAnimate', 'weeklyScheduler', 'weeklySchedulerI18N'])

  .config(['weeklySchedulerLocaleServiceProvider', function (localeServiceProvider) {
    localeServiceProvider.configure({
      doys: {'es-es': 4},
      lang: {'es-es': {month: 'Mes', weekNb: 'número de la semana', addNew: 'Añadir'}},
      localeLocationPattern: 'https://code.angularjs.org/1.5.8/i18n/angular-locale_ko-kr.js'
    });
  }])

  .controller('DemoController', ['$scope', '$timeout', 'weeklySchedulerLocaleService', '$log',
    function ($scope, $timeout, localeService, $log) {

      $scope.model = {
        locale: localeService.$locale.id,
        options: {/*monoSchedule: true*/},
        items: [{
          label: 'DS랩 하반기 일정',
          editable: false,
          visiable: "hidden",
          schedules: [
            {start: moment('2018-06-30').toDate(), end: moment('2019-01-01').toDate()}
          ]
        }]
      };

      $timeout(function () {
        $scope.model.items = $scope.model.items.concat([{
          label: '[프로젝트] ING생명',
          editable: false,
          schedules: [
             {start: moment('2018-08-01').toDate(), end: moment('2018-12-31').toDate()}
          ]
        },{
          label: '[연구] DS랩 뉴스레터 개발',
          editable: false,
          schedules: [
               {start: moment('2018-07-01').toDate(), end: moment('2018-07-20').toDate()}
          ]
        },{
          label: '[연구] DS랩 블로그 개발',
          editable: false,
          schedules: [
               {start: moment('2018-07-01').toDate(), end: moment('2018-07-30').toDate()}
          ]
        },{
          label: '[연구] Kaggle 대회 참여',
          editable: false,
          schedules: [
              {start: moment('2018-07-01').toDate(), end: moment('2018-07-30').toDate()}
          ]
        }]);
      }, 50);

      this.doSomething = function (itemIndex, scheduleIndex, scheduleValue) {
        $log.debug('The model has changed!', itemIndex, scheduleIndex, scheduleValue);
      };

      this.onLocaleChange = function () {
        $log.debug('The locale is changing to', $scope.model.locale);
        localeService.set($scope.model.locale).then(function ($locale) {
          $log.debug('The locale changed to', $locale.id);
        });
      };
    }]);