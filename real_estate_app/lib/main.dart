class AddInterger {
  int a;
  int b;
  AddInterger(this.a, this.b);
  int get add => a + b;
}


class ConcatinateString {
  String a;
  String b;
  ConcatinateString(this.a, this.b);
  String get concatinate => a + b;
}
void main() {
  var addNumber = AddInterger(1, 2);
  print(addNumber);
}
