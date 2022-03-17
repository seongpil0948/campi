# CampyCampyCampy


# INFO
* [FontAwesome](https://fontawesome.com/v5.15/icons?d=gallery&p=2)

# TODO
* 공통
  * 테스트 리스트 제작
* App
  * 로깅 필요 Crashristic
  * 푸시 메세지에 따라 페이지 이동 가능 하게끔. => O
  * 스플래쉬 이미지 campy 변경 =>  O
  * 로그인 페이지 campy 변경 =>  O
  * 사진 자르기 - 제출 -> 닫기 => O
  * 뒤로가기 두번 눌러야 꺼지거나 토스트 메시지로 꺼진다고 하거나 => O
  * 매거진 아이콘들에 가려짐 => O
  * 마이페이지
    * 다른사람 프로필 볼때 소개글 편집 안보이게 => O
    * 내가 내 프로필 볼때 팔로우 안보이게 => O
    * 내가 내프로필 볼때 소개글 편집 안보임 => O
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