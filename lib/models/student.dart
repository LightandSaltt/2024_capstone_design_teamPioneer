class Student {
  final String name;
  final String studentId;
  final String major;
  final int grade;
  final int semester;

  Student({
    required this.name,
    required this.studentId,
    required this.major,
    required this.grade,
    required this.semester,
  });

  // Firebase 데이터 형식으로 변환
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'studentId': studentId,
      'major': major,
      'grade': grade,
      'semester': semester,
    };
  }
}
