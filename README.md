# CampyCampyCampy


# TODO
미완료
----------------------------
* Web Engine
  * 테스트 리스트 제작

* App
  * 답글 작성시, 닉네임이 잘못되었다,,
  * https://pub.dev/packages/google_fonts
  * FutueBuilder 가 매 빌드마다 다시 실행 될 필요가 있을까? 아니다 didUpdateWidget 일때만 하면 된다
    * https://medium.com/saugo360/flutter-my-futurebuilder-keeps-firing-6e774830bc2
  * 신규 모델 제작시 테스트 개념으로 code generation 형식으로 가보자
    * https://firebase.flutter.dev/docs/firestore-odm/defining-models
    * https://pub.dev/packages/freezed
  *   로깅 필요 Crashristic, Analytics
      * 아예 작성이 안되는듯
  * 사진 확대/축소 기능


완료
----------------------------


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
* 매거진 작성시 Embeded builder 의 onTap 에문제가 있어 일단 child만 렌더링
* video_thumbnail 이놈 너무 느림
  * 일단 이미지로만 썸네일 제공 할수 있게끔 미리보기에서 파일로 보여주고 이후에는 파베 CDN 컨텐츠(썸네일 추출해서 파베에 올리는거임) 보여줄 수 있게끔  추후에 하는 걸로
* go web engine 내리고 firefunction 으로 옮기자,,?
* 최적화 (기한 미정)
* 함수 인자 context 등 컨텍스트가 필요할때 인자로 받을 필요 없이             
    그냥 그 위젯의 키를 가져와서 context.of(key) 하면됌
    아니면 https://www.youtube.com/watch?v=lytQi-slT5Y&list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG&index=1

# IDEAS
* 캠핑 주인 성격 더러운지 후기 나 별점 가능하게
* 캠핑 예약 수수료 없게끔