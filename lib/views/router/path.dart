const String splashPath = '/splash';
const String postListPath = '/postList';
const String feedPostPath = '$postListPath/feed/post';
const String mgzPostPath = '$postListPath/mgz/post';
const String mgzDetailPath = '/mgz/detail';
const String storePath = '/store';
const String loginPath = '/login';
const String unKnownPath = '/unknown';
const String rootPath = "/";
const String userPath = "/users";
const String chatPath = "/chat";

enum PageState { none, addPage, addAll, pop, replace, replaceAll }

enum Views {
  postListPage,
  feedDetail,
  feedPost,
  mgzPost,
  mgzDetail,
  storePage,
  productDetail,
  unknownPage,
  splashPage,
  loginPage,
  my,
  chatPage
}

class PageAction {
  late PageState state = PageState.addPage;
  late PiPathConfig page;
  PageAction.my(userId) : page = PiPathConfig.my();
  PageAction.feed() : page = postListPathConfig;
  PageAction.store() : page = storePathConfig;
  PageAction.productDetail(productId) {
    page = PiPathConfig.productDetail(productId: productId);
  }
  PageAction.feedDetail(feedId)
      : page = PiPathConfig.feedDetail(feedId: feedId);
  PageAction.feedPost() : page = feedPostPathConfig;
  PageAction.mgzPost() : page = mgzPostPathConfig;
  PageAction.mgzDetail(mgzId)
      : page = PiPathConfig.mgzDetailPathConfig(mgzId: mgzId);
  PageAction.chat() : page = chatPathConfig;
}

class PiPathConfig {
  final String key;
  final String path;
  final Views uiCtgr;
  PageAction? currentPageAction;
  String? productId;
  String? feedId;
  String? mgzId;

  @override
  String toString() {
    return "PiPathConfig: key: $key,  path: $path, uiCtgr$uiCtgr, currentPageAction: $currentPageAction";
  }

  PiPathConfig(
      {required this.key,
      required this.path,
      required this.uiCtgr,
      this.mgzId,
      this.productId,
      this.currentPageAction});

  PiPathConfig.feedDetail({required this.feedId})
      : key = 'FeedDetail',
        path = postListPath + '/$feedId',
        uiCtgr = Views.feedDetail;

  PiPathConfig.productDetail({required this.productId})
      : key = 'ProductDetail',
        path = storePath + '/products/$productId',
        uiCtgr = Views.productDetail;
  PiPathConfig.my()
      : key = 'MyMy',
        path = '$userPath/',
        uiCtgr = Views.my;
  PiPathConfig.mgzDetailPathConfig({required this.mgzId})
      : key = 'MgzDetail',
        path = mgzDetailPath,
        uiCtgr = Views.mgzDetail;
}

PiPathConfig postListPathConfig = PiPathConfig(
    key: 'Feed',
    path: postListPath,
    uiCtgr: Views.postListPage,
    currentPageAction: null);

PiPathConfig feedPostPathConfig = PiPathConfig(
    key: 'FeedPost',
    path: feedPostPath,
    uiCtgr: Views.feedPost,
    currentPageAction: null);
PiPathConfig mgzPostPathConfig = PiPathConfig(
    key: 'MgzPost',
    path: mgzPostPath,
    uiCtgr: Views.mgzPost,
    currentPageAction: null);

PiPathConfig storePathConfig = PiPathConfig(
    key: 'Store',
    path: storePath,
    uiCtgr: Views.storePage,
    currentPageAction: null);

PiPathConfig splashPathConfig = PiPathConfig(
    key: 'Splash',
    path: splashPath,
    uiCtgr: Views.splashPage,
    currentPageAction: null);

PiPathConfig loginPathConfig = PiPathConfig(
    key: 'Login',
    path: loginPath,
    uiCtgr: Views.loginPage,
    currentPageAction: null);

PiPathConfig unknownPathConfig = PiPathConfig(
    key: 'Unknown',
    path: unKnownPath,
    uiCtgr: Views.unknownPage,
    currentPageAction: null);

PiPathConfig chatPathConfig = PiPathConfig(
    key: 'Chat',
    path: chatPath,
    uiCtgr: Views.chatPage,
    currentPageAction: null);
