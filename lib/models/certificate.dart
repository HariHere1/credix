enum CertificateStatus {
  pending,
  autoApproved,
  flagged,
  reviewed,
  rejected,
}

enum ActivityGroup {
  groupI,
  groupII,
  groupIII,
}

class ExtractedFields {
  final String detectedType;
  final String issuer;
  final String duration;
  final String grade;
  final String completionDate;

  const ExtractedFields({
    required this.detectedType,
    required this.issuer,
    required this.duration,
    required this.grade,
    required this.completionDate,
  });
}

class Certificate {
  final String id;
  final String studentId;
  final String title;
  final String activityType;
  final ActivityGroup group;
  final String uploadDate;
  final CertificateStatus status;
  final String fileName;
  final ExtractedFields extractedFields;
  final String? flagReason;
  final String? rejectReason;
  final int pointsAwarded;
  final int pointsIfTrusted;

  const Certificate({
    required this.id,
    required this.studentId,
    required this.title,
    required this.activityType,
    required this.group,
    required this.uploadDate,
    required this.status,
    required this.fileName,
    required this.extractedFields,
    this.flagReason,
    this.rejectReason,
    required this.pointsAwarded,
    required this.pointsIfTrusted,
  });

  Certificate copyWith({
    String? id,
    String? studentId,
    String? title,
    String? activityType,
    ActivityGroup? group,
    String? uploadDate,
    CertificateStatus? status,
    String? fileName,
    ExtractedFields? extractedFields,
    String? flagReason,
    String? rejectReason,
    int? pointsAwarded,
    int? pointsIfTrusted,
  }) {
    return Certificate(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      title: title ?? this.title,
      activityType: activityType ?? this.activityType,
      group: group ?? this.group,
      uploadDate: uploadDate ?? this.uploadDate,
      status: status ?? this.status,
      fileName: fileName ?? this.fileName,
      extractedFields: extractedFields ?? this.extractedFields,
      flagReason: flagReason ?? this.flagReason,
      rejectReason: rejectReason ?? this.rejectReason,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
      pointsIfTrusted: pointsIfTrusted ?? this.pointsIfTrusted,
    );
  }
}
