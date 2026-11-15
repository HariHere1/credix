import '../models/audit_entry.dart';

class AuditService {
  AuditService._();
  static final AuditService instance = AuditService._();
  final List<AuditEntry> _entries = [
    AuditEntry(timestamp:DateTime.now().subtract(const Duration(minutes:2)),actor:'Admin System',role:'Super Admin',action:'Auto-approved',target:'NSS Leadership Programme · Maria Garcia',oldValue:'OCR verified',newValue:'Approved',reason:'High-confidence demo certificate passed automated checks'),
    AuditEntry(timestamp:DateTime.now().subtract(const Duration(minutes:14)),actor:'Admin System',role:'Super Admin',action:'Certificate received',target:'Seminar Project · Alex Johnson',oldValue:'Not submitted',newValue:'Pending',reason:'Demo certificate is waiting for tutor review'),
  ];
  List<AuditEntry> get entries => List.unmodifiable(_entries);
  void log({required String actor, required String role, required String action, required String target, required String oldValue, required String newValue, required String reason}) {
    assert(reason.trim().isNotEmpty, 'Audit reason is mandatory');
    _entries.insert(0, AuditEntry(timestamp:DateTime.now(),actor:actor,role:role,action:action,target:target,oldValue:oldValue,newValue:newValue,reason:reason.trim()));
  }
}
