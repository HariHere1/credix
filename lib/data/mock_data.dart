import '../models/models.dart';

const List<String> kActivityTypes = [
  'Hackathon',
  'Workshop',
  'Seminar',
  'Other',
];

// Small demo roster: Alex is below the requirement; Maria is the high scorer.
const Student kMockStudent = Student(
  id: 's001',
  name: 'Alex Johnson',
  rollNo: 'CS2021001',
  email: 'alex.j@college.edu',
  batch: '2021–2025',
  department: 'Computer Science & Engineering',
  password: 'student123',
);

const Student kHighScoringStudent = Student(
  id: 's002',
  name: 'Maria Garcia',
  rollNo: 'CS2021002',
  email: 'maria.g@college.edu',
  batch: '2021–2025',
  department: 'Computer Science & Engineering',
  password: 'student123',
);

const Advisor kMockAdvisor = Advisor(
  id: 'a001',
  name: 'Tinu Thomas',
  email: 'admin@gmail.com',
  department: 'Computer Science & Engineering',
  password: 'advisor123',
);

const List<Student> kMockStudents = [kMockStudent, kHighScoringStudent];

List<Certificate> kMockCertificates = [
  // Low-scoring student: one auto-approved, pending, flagged and rejected claim.
  Certificate(
    id: 'c001',
    studentId: 's001',
    title: 'NSS Participation',
    activityType: 'Other',
    group: ActivityGroup.groupI,
    uploadDate: '2024-08-15',
    status: CertificateStatus.autoApproved,
    fileName: 'hackathon_certificate.pdf',
    extractedFields: ExtractedFields(
      detectedType: 'NSS participation',
      issuer: 'College NSS Unit',
      duration: '30 hours',
      grade: 'Completed',
      completionDate: '2024-08-10',
    ),
    pointsAwarded: 12,
    pointsIfTrusted: 12,
  ),
  Certificate(
    id: 'c002',
    studentId: 's001',
    title: 'Seminar Project',
    activityType: 'Seminar',
    group: ActivityGroup.groupIII,
    uploadDate: '2024-10-05',
    status: CertificateStatus.pending,
    fileName: 'seminar_certificate.pdf',
    extractedFields: ExtractedFields(
      detectedType: 'Seminar',
      issuer: 'NPTEL',
      duration: '3 months',
      grade: 'B+',
      completionDate: '2024-10-01',
    ),
    pointsAwarded: 0,
    pointsIfTrusted: 20,
  ),
  Certificate(
    id: 'c003',
    studentId: 's001',
    title: 'Workshop Certificate',
    activityType: 'Workshop',
    group: ActivityGroup.groupII,
    uploadDate: '2024-09-20',
    status: CertificateStatus.flagged,
    fileName: 'workshop_certificate.jpg',
    extractedFields: ExtractedFields(
      detectedType: 'Seminar',
      issuer: 'ACM Student Chapter',
      duration: '8 hours',
      grade: 'N/A',
      completionDate: '2024-09-18',
    ),
    flagReason: 'Activity type does not match the certificate.',
    pointsAwarded: 0,
    pointsIfTrusted: 10,
  ),
  Certificate(
    id: 'c004',
    studentId: 's001',
    title: 'Introductory Hackathon',
    activityType: 'Hackathon',
    group: ActivityGroup.groupI,
    uploadDate: '2024-06-20',
    status: CertificateStatus.rejected,
    fileName: 'intro_hackathon_certificate.png',
    extractedFields: ExtractedFields(
      detectedType: 'Hackathon',
      issuer: 'Unknown issuer',
      duration: '10 hours',
      grade: 'C',
      completionDate: '2024-06-15',
    ),
    rejectReason: 'The certificate could not be verified.',
    pointsAwarded: 0,
    pointsIfTrusted: 8,
  ),

  // High-scoring student: 40 approved points in each group (120 total).
  Certificate(
    id: 'c005',
    studentId: 's002',
    title: 'NSS Leadership Programme',
    activityType: 'Other',
    group: ActivityGroup.groupI,
    uploadDate: '2024-08-10',
    status: CertificateStatus.autoApproved,
    fileName: 'national_hackathon_certificate.pdf',
    extractedFields: ExtractedFields(
      detectedType: 'NSS leadership programme',
      issuer: 'College NSS Unit',
      duration: '48 hours',
      grade: 'Completed',
      completionDate: '2024-08-08',
    ),
    pointsAwarded: 40,
    pointsIfTrusted: 40,
  ),
  Certificate(
    id: 'c006',
    studentId: 's002',
    title: 'Professional Workshop',
    activityType: 'Workshop',
    group: ActivityGroup.groupII,
    uploadDate: '2024-09-12',
    status: CertificateStatus.autoApproved,
    fileName: 'professional_workshop_certificate.pdf',
    extractedFields: ExtractedFields(
      detectedType: 'Workshop',
      issuer: 'TCS iON',
      duration: '40 hours',
      grade: 'Pass',
      completionDate: '2024-09-10',
    ),
    pointsAwarded: 40,
    pointsIfTrusted: 40,
  ),
  Certificate(
    id: 'c007',
    studentId: 's002',
    title: 'Research Publication',
    activityType: 'Other',
    group: ActivityGroup.groupIII,
    uploadDate: '2024-10-14',
    status: CertificateStatus.reviewed,
    fileName: 'research_publication_certificate.pdf',
    extractedFields: ExtractedFields(
      detectedType: 'Research Publication',
      issuer: 'Student Research Journal',
      duration: '1 publication',
      grade: 'Published',
      completionDate: '2024-10-12',
    ),
    pointsAwarded: 40,
    pointsIfTrusted: 40,
  ),
];

int getStudentPoints(String studentId) => kMockCertificates
    .where((c) =>
        c.studentId == studentId &&
        (c.status == CertificateStatus.autoApproved ||
            c.status == CertificateStatus.reviewed))
    .fold(0, (sum, c) => sum + c.pointsAwarded);

int getGroupPoints(String studentId, ActivityGroup group) => kMockCertificates
    .where((c) =>
        c.studentId == studentId &&
        c.group == group &&
        (c.status == CertificateStatus.autoApproved ||
            c.status == CertificateStatus.reviewed))
    .fold(0, (sum, c) => sum + c.pointsAwarded);

List<Certificate> getStudentCertificates(String studentId) =>
    kMockCertificates.where((c) => c.studentId == studentId).toList();

Map<String, int> getStudentSemesterPoints(String studentId) {
  final student = getStudentById(studentId);
  final startYear = int.tryParse(
      RegExp(r'\d{4}').firstMatch(student?.batch ?? '')?.group(0) ?? '');
  final totals = <String, int>{};
  for (final certificate in kMockCertificates.where((c) =>
      c.studentId == studentId &&
      (c.status == CertificateStatus.autoApproved ||
          c.status == CertificateStatus.reviewed))) {
    final date = DateTime.tryParse(certificate.uploadDate);
    if (date == null) continue;
    final academicStart = date.month >= 8 ? date.year : date.year - 1;
    final semester = startYear == null
        ? 1
        : ((academicStart - startYear) * 2) + (date.month >= 8 ? 1 : 2);
    final key = 'Semester ${semester.clamp(1, 8)}';
    totals.update(key, (points) => points + certificate.pointsAwarded,
        ifAbsent: () => certificate.pointsAwarded);
  }
  return totals;
}

List<Certificate> getFlaggedCertificates() =>
    kMockCertificates.where((c) => c.status == CertificateStatus.flagged).toList();

Student? getStudentById(String id) {
  for (final student in kMockStudents) {
    if (student.id == id) return student;
  }
  return null;
}
