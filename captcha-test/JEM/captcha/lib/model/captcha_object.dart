class CaptchaObject {
  String image;
  List<String> values;
  Map<String, bool> options;

  CaptchaObject(String image, List<String> values, Map<String, bool> options) {
    this.image = image;
    this.values = values;
    this.options = options;
  }
}
