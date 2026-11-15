import '../mock_data/admin_mock_data.dart';

abstract interface class DashboardRepository {
  List<DepartmentSnapshot> get departments;
  int get enrolled;
  int get eligible;
  int get submissions;
  int get pending;
  int get flagged;
  int get verified;
}

class MockDashboardRepository implements DashboardRepository {
  const MockDashboardRepository();
  @override
  List<DepartmentSnapshot> get departments => AdminMockData.departments;
  @override
  int get enrolled => AdminMockData.enrolled;
  @override
  int get eligible => AdminMockData.eligible;
  @override
  int get submissions => AdminMockData.submissionCount;
  @override
  int get pending => AdminMockData.pending;
  @override
  int get flagged => AdminMockData.flagged;
  @override
  int get verified => AdminMockData.verified;
}
