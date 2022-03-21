# CampyCampyCampy


# INFO
* [FontAwesome](https://fontawesome.com/v5.15/icons?d=gallery&p=2)

# TODO
* 공통
  * 테스트 리스트 제작
* App
  * 최적화 (기한 미정)
    * part of 로 모듈 분리, 
  * 함수 인자 context 등 컨텍스트가 필요할때 인자로 받을 필요 없이
    그냥 그 위젯의 키를 가져와서 context.of(key) 하면됌
    아니면 https://www.youtube.com/watch?v=lytQi-slT5Y&list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG&index=1
    1분 7초 참고
    * Freezed State 관리
  *   로깅 필요 Crashristic, Analytics
      * 아예 작성이 안되는듯
  * 삭제, 수정 논의
    * 수정은,, 포스팅 페이지에서 기존 데이터 State 가 들어오면 에딧모드 
      활성화, 저장시에도 덮어쓰기로 할 수 있게끔 
    * 삭제는,, 성훈이랑 논의


  * 푸쉬메시지 사용자 이름 null로 뜸 => O
  * 사진자르기 => O
    * 확인 누르면 자르기 사진 목록에서 삭제 및 넘어갈수 있도록 (백그라운드 이미지도 넘어가게 할 수 있도)=> O
  * 왜 앱이 안켜지고 => O
  * 성훈이가 내걸로 로그인됌? => O
  * 포스팅 2 => sns 1 포스팅 1 => O
  * 매거진  (지속적인 흠 필요)
    * 작성 => O
      * 이미지 근처 커서 잘 안뜨는거랑 전체적으로 사용감 향상 해야함 => O
    * 디테일 => O
      * 편집, 좋아요, 댓글,  => O
      * 타이틀 맨위에 보이게 => O
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
* 매거진 작성시 Embeded builder 의 onTap 에문제가 있어 일단 child만 렌더링
* video_thumbnail 이놈 너무 느림
  * 일단 이미지로만 썸네일 제공 할수 있게끔 미리보기에서 파일로 보여주고 이후에는 파베 CDN 컨텐츠(썸네일 추출해서 파베에 올리는거임) 보여줄 수 있게끔  추후에 하는 걸로


# IDEAS
* 캠핑 주인 성격 더러운지 후기 나 별점 가능하게
* 캠핑 예약 수수료 없게끔