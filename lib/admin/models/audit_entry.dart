class AuditEntry {
  const AuditEntry({required this.timestamp, required this.actor, required this.role, required this.action, required this.target, required this.oldValue, required this.newValue, required this.reason});
  final DateTime timestamp;
  final String actor, role, action, target, oldValue, newValue, reason;
}
