import '../../data/mock_data.dart';
import '../../models/certificate.dart';

class DepartmentSnapshot {
  const DepartmentSnapshot(this.name, this.students, this.eligible, this.avgPoints);
  final String name;
  final int students;
  final int eligible;
  final double avgPoints;
}

class AdminMockData {
  static List<DepartmentSnapshot> get departments {
    if (kMockStudents.isEmpty) return const [];
    final totalPoints = kMockStudents.fold<int>(
        0, (sum, student) => sum + getStudentPoints(student.id));
    final eligible = kMockStudents
        .where((student) => getStudentPoints(student.id) >= 120)
        .length;
    return [
      DepartmentSnapshot(
        kMockStudents.first.department,
        enrolled,
        eligible,
        enrolled == 0 ? 0 : totalPoints / enrolled,
      ),
    ];
  }

  static int get enrolled => kMockStudents.length;
  static int get eligible => departments.fold(0, (a, b) => a + b.eligible);
  static int get submissionCount => kMockCertificates.length;
  static int get pending => kMockCertificates
      .where((certificate) => certificate.status == CertificateStatus.pending)
      .length;
  static int get flagged => kMockCertificates
      .where((certificate) => certificate.status == CertificateStatus.flagged)
      .length;
  static int get adminAttention => pending + flagged;
  static int get verified => kMockCertificates
      .where((certificate) =>
          certificate.status == CertificateStatus.autoApproved)
      .length;
  static const activities = <(String, String)>[
    ('Group I', 'NSS, arts, sports and club activities'),
    ('Group II', 'Workshops, internships and conferences'),
    ('Group III', 'Research, innovation and publications'),
  ];
}

