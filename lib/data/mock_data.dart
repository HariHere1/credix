import '../models/models.dart';

// Activity type placeholders (no real rulebook data)
const List<String> kActivityTypes = [
  'Hackathon',
  'Workshop',
  'Seminar',
  'Other',
];

// Login accounts
const Student kMockStudent = Student(
  id: 's001',
  name: 'Alex Johnson',
  rollNo: 'CS2021001',
  email: 'alex.j@college.edu',
  batch: '2021–2025',
  department: 'Computer Science',
  password: 'student123',
);

const Advisor kMockAdvisor = Advisor(
  id: 'a001',
  name: 'Dr. Priya Nair',
  email: 'priya.nair@college.edu',
  department: 'Computer Science',
  password: 'advisor123',
);

const List<Student> kMockStudents = [
  Student(id: 's001', name: 'Alex Johnson', rollNo: 'CS2021001', email: 'alex.j@college.edu', batch: '2021–2025', department: 'Computer Science', password: 'student123'),
  Student(id: 's002', name: 'Maria Garcia', rollNo: 'CS2021002', email: 'maria.g@college.edu', batch: '2021–2025', department: 'Computer Science', password: 'student123'),
  Student(id: 's003', name: 'Rohan Patel', rollNo: 'CS2021003', email: 'rohan.p@college.edu', batch: '2021–2025', department: 'Computer Science', password: 'student123'),
  Student(id: 's004', name: 'Lena Schmidt', rollNo: 'CS2022001', email: 'lena.s@college.edu', batch: '2022–2026', department: 'Computer Science', password: 'student123'),
  Student(id: 's005', name: 'Chen Wei', rollNo: 'CS2022002', email: 'chen.w@college.edu', batch: '2022–2026', department: 'Computer Science', password: 'student123'),
  Student(id: 's006', name: 'Aisha Okonkwo', rollNo: 'CS2022003', email: 'aisha.o@college.edu', batch: '2022–2026', department: 'Computer Science', password: 'student123'),
  Student(id: 's007', name: 'James Nguyen', rollNo: 'CS2023001', email: 'james.n@college.edu', batch: '2023–2027', department: 'Computer Science', password: 'student123'),
  Student(id: 's008', name: 'Sara Ali', rollNo: 'CS2023002', email: 'sara.a@college.edu', batch: '2023–2027', department: 'Computer Science', password: 'student123'),
];

List<Certificate> kMockCertificates = [
  // Approved / reviewed (counted toward points)
  Certificate(
    id: 'c001', studentId: 's001', title: 'Hackathon Completion', activityType: 'Hackathon', group: ActivityGroup.groupI,
    uploadDate: '2024-08-15', status: CertificateStatus.autoApproved, fileName: 'activity1_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Hackathon', issuer: 'IEEE Student Branch', duration: '30 hours', grade: 'A', completionDate: '2024-08-10'),
    pointsAwarded: 15, pointsIfTrusted: 15,
  ),
  Certificate(
    id: 'c002', studentId: 's002', title: 'Hackathon Advanced', activityType: 'Hackathon', group: ActivityGroup.groupI,
    uploadDate: '2024-07-10', status: CertificateStatus.reviewed, fileName: 'advanced_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Hackathon', issuer: 'IEEE Student Branch', duration: '60 hours', grade: 'A+', completionDate: '2024-07-05'),
    pointsAwarded: 20, pointsIfTrusted: 20,
  ),
  Certificate(
    id: 'c003', studentId: 's003', title: 'Workshop Certificate', activityType: 'Workshop', group: ActivityGroup.groupII,
    uploadDate: '2024-09-01', status: CertificateStatus.autoApproved, fileName: 'test2_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Workshop', issuer: 'TCS iON', duration: '20 hours', grade: 'Pass', completionDate: '2024-08-28'),
    pointsAwarded: 10, pointsIfTrusted: 10,
  ),
  Certificate(
    id: 'c004', studentId: 's005', title: 'Hackathon Online', activityType: 'Hackathon', group: ActivityGroup.groupI,
    uploadDate: '2024-08-05', status: CertificateStatus.autoApproved, fileName: 'online_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Hackathon', issuer: 'Coursera', duration: '40 hours', grade: 'B', completionDate: '2024-08-01'),
    pointsAwarded: 12, pointsIfTrusted: 12,
  ),
  Certificate(
    id: 'c005', studentId: 's007', title: 'Seminar Expo', activityType: 'Seminar', group: ActivityGroup.groupIII,
    uploadDate: '2024-10-02', status: CertificateStatus.autoApproved, fileName: 'expo_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Seminar', issuer: 'Tech Expo', duration: '3 days', grade: 'Participated', completionDate: '2024-09-30'),
    pointsAwarded: 8, pointsIfTrusted: 8,
  ),
  Certificate(
    id: 'c006', studentId: 's008', title: 'Workshop Symposium', activityType: 'Workshop', group: ActivityGroup.groupII,
    uploadDate: '2024-09-25', status: CertificateStatus.reviewed, fileName: 'symposium_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Workshop', issuer: 'IEDC', duration: '1 day', grade: 'N/A', completionDate: '2024-09-23'),
    pointsAwarded: 6, pointsIfTrusted: 6,
  ),

  // Pending
  Certificate(
    id: 'c007', studentId: 's001', title: 'Seminar Project', activityType: 'Seminar', group: ActivityGroup.groupIII,
    uploadDate: '2024-10-05', status: CertificateStatus.pending, fileName: 'project_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Seminar', issuer: 'NPTEL', duration: '3 months', grade: 'B+', completionDate: '2024-10-01'),
    pointsAwarded: 0, pointsIfTrusted: 20,
  ),
  Certificate(
    id: 'c008', studentId: 's004', title: 'Workshop Seminar', activityType: 'Workshop', group: ActivityGroup.groupII,
    uploadDate: '2024-10-01', status: CertificateStatus.pending, fileName: 'seminar_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Workshop', issuer: 'IIT Madras', duration: '1 day', grade: 'N/A', completionDate: '2024-09-29'),
    pointsAwarded: 0, pointsIfTrusted: 5,
  ),

  // Flagged (with the allowed mock reasons)
  Certificate(
    id: 'c009', studentId: 's001', title: 'Workshop Seminar', activityType: 'Workshop', group: ActivityGroup.groupII,
    uploadDate: '2024-09-20', status: CertificateStatus.flagged, fileName: 'workshop_cert.jpg',
    extractedFields: ExtractedFields(detectedType: 'Seminar', issuer: 'ACM Student Chapter', duration: '8 hours', grade: 'N/A', completionDate: '2024-09-18'),
    flagReason: 'Type mismatch', pointsAwarded: 0, pointsIfTrusted: 10,
  ),
  Certificate(
    id: 'c010', studentId: 's002', title: 'Other Activity - Hackathon', activityType: 'Other', group: ActivityGroup.groupII,
    uploadDate: '2024-08-30', status: CertificateStatus.flagged, fileName: 'hackathon_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Other', issuer: 'Coding Ninjas', duration: '48 hours', grade: 'Winner', completionDate: '2024-08-28'),
    flagReason: '"Other" activity', pointsAwarded: 0, pointsIfTrusted: 25,
  ),
  Certificate(
    id: 'c011', studentId: 's003', title: 'Seminar Advanced', activityType: 'Seminar', group: ActivityGroup.groupIII,
    uploadDate: '2024-09-15', status: CertificateStatus.flagged, fileName: 'test3_advanced.pdf',
    extractedFields: ExtractedFields(detectedType: 'Workshop', issuer: 'Coursera', duration: '5 months', grade: 'A', completionDate: '2024-09-10'),
    flagReason: 'Low OCR confidence', pointsAwarded: 0, pointsIfTrusted: 30,
  ),
  Certificate(
    id: 'c012', studentId: 's005', title: 'Seminar Research', activityType: 'Seminar', group: ActivityGroup.groupIII,
    uploadDate: '2024-07-25', status: CertificateStatus.flagged, fileName: 'research_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Seminar', issuer: 'Red Hat Academy', duration: '6 months', grade: 'A', completionDate: '2024-07-20'),
    flagReason: 'Duplicate file', pointsAwarded: 0, pointsIfTrusted: 35,
  ),
  Certificate(
    id: 'c013', studentId: 's006', title: 'Workshop Competition', activityType: 'Workshop', group: ActivityGroup.groupII,
    uploadDate: '2024-09-10', status: CertificateStatus.flagged, fileName: 'competition_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Workshop', issuer: 'Google Developers', duration: '2 days', grade: '2nd Place', completionDate: '2024-09-08'),
    flagReason: 'Name mismatch', pointsAwarded: 0, pointsIfTrusted: 18,
  ),
  Certificate(
    id: 'c014', studentId: 's008', title: 'Hackathon Bootcamp', activityType: 'Hackathon', group: ActivityGroup.groupI,
    uploadDate: '2024-08-20', status: CertificateStatus.flagged, fileName: 'bootcamp_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Hackathon', issuer: 'CodeChef Chapter', duration: '2 weeks', grade: 'A', completionDate: '2024-08-15'),
    flagReason: 'Near-duplicate text', pointsAwarded: 0, pointsIfTrusted: 22,
  ),
  Certificate(
    id: 'c015', studentId: 's007', title: 'Hackathon Workshop', activityType: 'Hackathon', group: ActivityGroup.groupI,
    uploadDate: '2024-10-03', status: CertificateStatus.flagged, fileName: 'tampered_cert.jpg',
    extractedFields: ExtractedFields(detectedType: 'Hackathon', issuer: 'Infosys Springboard', duration: '15 hours', grade: 'A', completionDate: '2024-09-28'),
    flagReason: 'Possible tampering', pointsAwarded: 0, pointsIfTrusted: 10,
  ),
  Certificate(
    id: 'c016', studentId: 's006', title: 'Seminar Workshop', activityType: 'Seminar', group: ActivityGroup.groupIII,
    uploadDate: '2024-10-04', status: CertificateStatus.flagged, fileName: 'incomplete_cert.pdf',
    extractedFields: ExtractedFields(detectedType: 'Seminar', issuer: 'Udemy', duration: 'N/A', grade: 'N/A', completionDate: '2024-10-01'),
    flagReason: 'Missing field', pointsAwarded: 0, pointsIfTrusted: 15,
  ),

  // Rejected
  Certificate(
    id: 'c017', studentId: 's004', title: 'Hackathon Intro', activityType: 'Hackathon', group: ActivityGroup.groupI,
    uploadDate: '2024-06-20', status: CertificateStatus.rejected, fileName: 'intro_cert.png',
    extractedFields: ExtractedFields(detectedType: 'Hackathon', issuer: 'Unknown', duration: '10 hours', grade: 'C', completionDate: '2024-06-15'),
    rejectReason: 'Certificate appears tampered. Issuer not recognized.', pointsAwarded: 0, pointsIfTrusted: 8,
  ),
];

// Helpers
int getStudentPoints(String studentId) {
  return kMockCertificates
      .where((c) =>
          c.studentId == studentId &&
          (c.status == CertificateStatus.autoApproved || c.status == CertificateStatus.reviewed))
      .fold(0, (sum, c) => sum + c.pointsAwarded);
}

int getGroupPoints(String studentId, ActivityGroup group) {
  return kMockCertificates
      .where((c) =>
          c.studentId == studentId &&
          c.group == group &&
          (c.status == CertificateStatus.autoApproved || c.status == CertificateStatus.reviewed))
      .fold(0, (sum, c) => sum + c.pointsAwarded);
}

List<Certificate> getStudentCertificates(String studentId) {
  return kMockCertificates.where((c) => c.studentId == studentId).toList();
}

List<Certificate> getFlaggedCertificates() {
  return kMockCertificates.where((c) => c.status == CertificateStatus.flagged).toList();
}

Student? getStudentById(String id) {
  try {
    return kMockStudents.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
}
