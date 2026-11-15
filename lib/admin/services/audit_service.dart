import '../models/audit_entry.dart';

class AuditService {
  AuditService._();
  static final AuditService instance = AuditService._();
  final List<AuditEntry> _entries = [
    AuditEntry(timestamp:DateTime.now().subtract(const Duration(minutes:2)),actor:'Dr. Anand R.',role:'Super Admin',action:'Rule viewed',target:'Group I cap',oldValue:'40 points',newValue:'40 points',reason:'Read-only event'),
    AuditEntry(timestamp:DateTime.now().subtract(const Duration(minutes:14)),actor:'Dr. Elizabeth Joseph',role:'Department Admin',action:'Batch approved',target:'18 conference claims',oldValue:'Pending',newValue:'Approved',reason:'Documents verified against original certificates'),
    AuditEntry(timestamp:DateTime.now().subtract(const Duration(minutes:32)),actor:'Admin System',role:'Super Admin',action:'OCR scan',target:'45 certificates',oldValue:'Queued',newValue:'Scanned; 0 duplicate matches',reason:'Scheduled processing'),
  ];
  List<AuditEntry> get entries => List.unmodifiable(_entries);
  void log({required String actor, required String role, required String action, required String target, required String oldValue, required String newValue, required String reason}) {
    assert(reason.trim().isNotEmpty, 'Audit reason is mandatory');
    _entries.insert(0, AuditEntry(timestamp:DateTime.now(),actor:actor,role:role,action:action,target:target,oldValue:oldValue,newValue:newValue,reason:reason.trim()));
  }
}
