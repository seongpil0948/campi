# CampyCampyCampy


# INFO
* [FontAwesome](https://fontawesome.com/v5.15/icons?d=gallery&p=2)

# TODO
* Camping SNS 사진 안올라감 = O
* 뒤로가기 방지 = ㅇ
* 사진 자르기 가로가 더긴 사진일 경우에까지 고려 해야함, 안되는 중 O
* 게시글 올린후 올린 게시글이 받아와 지질 않고 너무 오래걸림 시이팔
* 검색 두번 눌러야 태그 검색 됌
* 팔로워 팔로우 이상함
* 마이페이지 좁은 화면에서 깨짐 현상
* 확대 안됌.



## 정식 배포 전
* 피드, 매거진 필터링 가능하게끔
  * 피드랑 매거진 컬렉션 유저랑 분리해야함 쿼리 비효율적인듯
  * 포스팅은 다보이게끔 (인기글, 최신글)
* 로고 만들어지면 IOS, Android 출시 필요이미지, 아이콘이미지
* 백엔드 API 이후 fcm.sendPushMessage 활성화
## 정식 배포 후
* BlocBuilder 나 Provider들 Consumer 나 Selector 사용해서 최적화
* 버전 별 Git Tagging 해서 백업 및 Revert 정책 필요.
* Kakao
  * https://pub.dev/packages/kakao_flutter_sdk
* 인스타나 다른 앱에 연결하거나 공유할때
  * https://firebase.flutter.dev/docs/dynamic-links/overview/
  * https://firebase.google.com/products/dynamic-links
  * https://eunjin3786.tistory.com/292
* CI/CD
  * [IOS CD](https://docs.github.com/en/actions/deployment/deploying-xcode-applications/installing-an-apple-certificate-on-macos-runners-for-xcode-development)
* 결제 시스템
  * https://github.com/iamport/iamport_flutter
  * https://github.com/bootpay/flutter


# Agenda
* video_thumbnail 이놈 너무 느림
  * 일단 이미지로만 썸네일 제공 할수 있게끔 미리보기에서 파일로 보여주고 이후에는 파베 CDN 컨텐츠(썸네일 추출해서 파베에 올리는거임) 보여줄 수 있게끔  추후에 하는 걸로


# IDEAS
* 캠핑 주인 성격 더러운지 후기 나 별점 가능하게
* 캠핑 예약 수수료 없게끔