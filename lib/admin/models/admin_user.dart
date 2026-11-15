enum AdminRole { superAdmin, departmentAdmin, auditor }

extension AdminRoleLabel on AdminRole {
  String get label => switch (this) {
        AdminRole.superAdmin => 'Super Admin',
        AdminRole.departmentAdmin => 'Department Admin',
        AdminRole.auditor => 'Auditor',
      };

  bool get canEdit => this != AdminRole.auditor;
}

class AdminUser {
  const AdminUser({
    required this.name,
    required this.email,
    required this.role,
    this.department = 'Computer Science & Engineering',
  });

  final String name;
  final String email;
  final AdminRole role;
  final String department;
}
