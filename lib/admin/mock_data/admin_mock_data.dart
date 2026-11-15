class DepartmentSnapshot {
  const DepartmentSnapshot(this.name, this.students, this.eligible, this.avgPoints);
  final String name;
  final int students;
  final int eligible;
  final double avgPoints;
}

class AdminMockData {
  static const departments = <DepartmentSnapshot>[
    DepartmentSnapshot('Computer Science & Engineering', 240, 210, 132),
    DepartmentSnapshot('Artificial Intelligence & Data Science', 160, 136, 128),
    DepartmentSnapshot('Electronics & Communication Engg.', 200, 165, 124),
    DepartmentSnapshot('Mechanical Engineering', 180, 130, 118),
    DepartmentSnapshot('Civil Engineering', 160, 110, 115),
    DepartmentSnapshot('Electrical & Electronics Engg.', 140, 95, 116),
    DepartmentSnapshot('Information Technology', 200, 100, 121),
    DepartmentSnapshot('Chemical Engineering', 200, 94, 113),
  ];
  static int get enrolled => departments.fold(0, (a, b) => a + b.students);
  static int get eligible => departments.fold(0, (a, b) => a + b.eligible);
  static const submissionCount = 8924;
  static const pending = 142;
  static const flagged = 28;
  static const overdue = 62;
  static const adminAttention = flagged + overdue;
  static const verified = 6240;
  static const activities = <String>[
    'NSS / NCC / NSO', 'Arts, sports and games', 'Union and club activities',
    'English proficiency certificate', 'Short-term internship', 'Conference or workshop',
    'Journal publication', 'Patent or innovation',
  ];
}
