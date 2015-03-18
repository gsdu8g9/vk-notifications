var accessToken = '09c001593b3f728c492668b5f140a8940e7de0b46273e2c7e869e7e054348af2f5dde5591b542dadb6e47';
var groupIds = ['-51634849', '-37915106'];

angular.module('httpReal', ['ng'])
  .config(['$provide', function ($provide) {
    $provide.decorator('$httpBackend', function () {
      return angular.injector(['ng']).get('$httpBackend');
    });
  }])
  .service('httpReal', ['$rootScope', function ($rootScope) {
    this.submit = function () {
      $rootScope.$digest();
    };
  }]);

function fakeResolve(value) {
  return {
    then: function(callback) {
      callback(value);
    }
  }
}

describe('Post', function () {
  var Post, $rootScope;

  beforeEach(module('vk-news', 'httpReal'));

  beforeEach(inject(function (_Post_, _$rootScope_, SyncStorage) {
    Post = _Post_;
    $rootScope = _$rootScope_;

    sinon.stub(SyncStorage, 'getValue', function (value) {
      if (value === 'group_ids') {
        return fakeResolve(groupIds);
      }
    });
  }));

  describe('.query', function () {
    it('returns object with posts and posts_count keys', function (done) {
      Post.query(accessToken).then(function (response) {
        var data = response;

        expect(data).to.have.property('posts');
        expect(data.posts.length).to.equal(20);
        expect(data.posts_count[groupIds[0]]).not.to.equal(undefined);
        expect(data.posts_count[groupIds[1]]).not.to.equal(undefined);

        done();
      });

      $rootScope.$digest();
    });
  });
});
