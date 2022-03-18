# CampyCampyCampy


# INFO
* [FontAwesome](https://fontawesome.com/v5.15/icons?d=gallery&p=2)

# TODO
* 공통
  * 테스트 리스트 제작
* App
  * 로깅 필요 Crashristic
  * 매거진 작성
    * 이미지 근처 커서 잘 안뜨는거랑 전체적으로 사용감 향상 해야함
    * writerId가 안들어가는듯
  * 푸쉬메시지 사용자 이름 null로 뜸
  * 사진자르기
    * 자르는 동안 액션 못하게 로딩
    * 확인 누르면 자르기 사진 목록에서 삭제 및 넘어갈수 있도록 (백그라운드 이미지도 넘어가게 할 수 있도)
  * 왜 앱이 안켜지고
  * 성훈이가 내걸로 로그인됌?
  * 포스팅 2 => sns 1 포스팅 1
* App Engine
  * 로깅 필요

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