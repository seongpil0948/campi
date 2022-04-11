# CampyCampyCampy


# TODO
* 트랜잭션 분리
  * 좋아요
  * 팔로우
  * 알람


* 마이페이지 게시글 목록 정렬순서 변경시에도 업데이트 안됌
* 알람 뱃지 구현 => O
  * 푸쉬 메시지 수신시 푸쉬알림 카운트 += 1 => O
  * 푸쉬 메시지 리스트 확인시  알림 카운트 = 0 -> hide => O
  * 뱃지 클릭시  알림 리스트 구현 ( 일자별 ) => O
* 매거진, SNS 
  * 썸네일 좋아요, 댓글 수 표시
    * 모델에 카운트를 함께저장하든, 트랜잭션으로 동기화 가능하게끔 하자!
  * 매거진, SNS 업로드이후 리스트에 표시가 안됌,,,,
  * 디테일 상단에 UserRow 및 팔로우버튼등 분리
* 매거진
  * 작성
    * 포스팅에 이미지 위젯 양쪽 패딩이나 마진 들어가면 빼도록
    * 포스팅 작성시 RichText로 태그 자동입력 할 수 있도록 -- 추후 
  * 디테일
    * 상단 UserRow 오른쪽에 팔로우 버튼 추가

----------------------------
* Web Engine
  * 테스트 리스트 제작

* App
  * 성훈이 폰트 반영
  * 매거진 좋아요 클릭시 DB 미반영됌 (푸쉬알림 및 화면엔 반영);
  * 받아올때 좋아요 오더바이 잘되는지 확인
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
* 답글 작성시, 닉네임이 코멘트 작성자로 보이는 현상 수정
* 

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