//225 is the average of human reading word per min.
int calculateReadingTime(String content) {
  final int wordCount = content.split(RegExp(r'\s+')).length;

  final readingTime = wordCount / 225;

  return readingTime.ceil();
}
