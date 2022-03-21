part of 'index.dart';

void oneMoreImg(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext nestedcontext) {
        return const AlertDialog(content: Text("이미지를 하나이상 첨부 해주세요."));
      });
}
