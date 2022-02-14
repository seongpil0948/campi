# CampyCampyCampy


# INFO
* [FontAwesome](https://fontawesome.com/v5.15/icons?d=gallery&p=2)

# Pending Design
* 블로그 작성 레이아웃
* 자기소개 수정 레이아웃
* 구글맵 비용 때문에 카드 받아야 할듯
  * 성훈인 뭐든 돈나가야 아까워서 할 스타일
* 피드, 포스트 필터링 레이아웃
* 이미지 받기
* 피드 포스트 나눈 페이지
* 마이에서 탭으로 나눈 페이지

# TODO:
피드 매거진 페이지 나눠서 페이지네이션 기능 구현
## 정식 배포 전
* 피드, 매거진 필터링 가능하게끔
  * 피드랑 매거진 컬렉션 유저랑 분리해야함 쿼리 비효율적인듯
  * 포스팅은 다보이게끔 (인기글, 최신글)
* 로고 만들어지면 IOS, Android 출시 필요이미지, 아이콘이미지
* 백엔드 API 이후 fcm.sendPushMessage 활성화
## 정식 배포 후
* 버전 별 Git Tagging 해서 백업 및 Revert 정책 필요.
* Kakao
  * https://pub.dev/packages/kakao_flutter_sdk
* 인스타나 다른 앱에 연결하거나 공유할때
  * https://firebase.flutter.dev/docs/dynamic-links/overview/
  * https://firebase.google.com/products/dynamic-links
  * https://eunjin3786.tistory.com/292
* CI/CD
  * [IOS CD](https://docs.github.com/en/actions/deployment/deploying-xcode-applications/installing-an-apple-certificate-on-macos-runners-for-xcode-development)


# Agenda
* video_thumbnail 이놈 너무 느림
  * 일단 이미지로만 썸네일 제공 할수 있게끔 미리보기에서 파일로 보여주고 이후에는 파베 CDN 컨텐츠(썸네일 추출해서 파베에 올리는거임) 보여줄 수 있게끔  추후에 하는 걸로


# IDEAS
* 캠핑 주인 성격 더러운지 후기 나 별점 가능하게
* 캠핑 예약 수수료 없게끔