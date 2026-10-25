import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

import '../models/database.dart';

// ---------------------------------------------------------------------------
// Doctor
// ---------------------------------------------------------------------------

Doctor doctorFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Doctor(
    id: doc.id,
    name: d['name'] as String? ?? '',
    specialization: d['specialization'] as String? ?? '',
    clinicAddress: d['clinicAddress'] as String? ?? '',
    phone: d['phone'] as String? ?? '',
    territory: d['territory'] as String? ?? '',
    classification: d['classification'] as String? ?? 'C',
    lastVisitDate: (d['lastVisitDate'] as Timestamp?)?.toDate(),
    visitFrequency: d['visitFrequency'] as int? ?? 0,
    conversionProbability:
        (d['conversionProbability'] as num?)?.toDouble() ?? 0.0,
    latitude: (d['latitude'] as num?)?.toDouble() ?? 0.0,
    longitude: (d['longitude'] as num?)?.toDouble() ?? 0.0,
  );
}

Map<String, dynamic> doctorToFirestore(Doctor d) => {
      'name': d.name,
      'specialization': d.specialization,
      'clinicAddress': d.clinicAddress,
      'phone': d.phone,
      'territory': d.territory,
      'classification': d.classification,
      'lastVisitDate':
          d.lastVisitDate != null ? Timestamp.fromDate(d.lastVisitDate!) : null,
      'visitFrequency': d.visitFrequency,
      'conversionProbability': d.conversionProbability,
      'latitude': d.latitude,
      'longitude': d.longitude,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// DCR
// ---------------------------------------------------------------------------

Dcr dcrFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Dcr(
    id: doc.id,
    doctorName: d['doctorName'] as String? ?? '',
    doctorId: d['doctorId'] as String? ?? '',
    productsDiscussed: d['productsDiscussed'] as String? ?? '',
    productsDetailed: d['productsDetailed'] as String? ?? '',
    samplesGiven: d['samplesGiven'] as String? ?? '',
    giftsGiven: d['giftsGiven'] as String? ?? '',
    followUpDate: d['followUpDate'] != null
        ? (d['followUpDate'] is Timestamp
            ? (d['followUpDate'] as Timestamp).toDate()
            : DateTime.tryParse(d['followUpDate'] as String))
        : null,
    notes: d['notes'] as String? ?? '',
    callDuration: d['callDuration'] as int? ?? 0,
    geoLat: (d['geoLat'] as num?)?.toDouble() ?? 0.0,
    geoLng: (d['geoLng'] as num?)?.toDouble() ?? 0.0,
    createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    mrId: d['mrId'] as String? ?? '',
  );
}

Map<String, dynamic> dcrToFirestore(Dcr d) => {
      'doctorName': d.doctorName,
      'doctorId': d.doctorId,
      'productsDiscussed': d.productsDiscussed,
      'productsDetailed': d.productsDetailed,
      'samplesGiven': d.samplesGiven,
      'giftsGiven': d.giftsGiven,
      'followUpDate': d.followUpDate?.toIso8601String(),
      'notes': d.notes,
      'callDuration': d.callDuration,
      'geoLat': d.geoLat,
      'geoLng': d.geoLng,
      'createdAt': Timestamp.fromDate(d.createdAt),
      'mrId': d.mrId,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// Expense
// ---------------------------------------------------------------------------

Expense expenseFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Expense(
    id: doc.id,
    amount: (d['amount'] as num?)?.toDouble() ?? 0.0,
    date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    category: ExpenseCategory
        .values[(d['category'] as int? ?? 0).clamp(0, ExpenseCategory.values.length - 1)],
    receiptImagePath: d['receiptImagePath'] as String?,
    isApproved: d['isApproved'] as bool? ?? false,
    warningFlag: d['warningFlag'] as bool? ?? false,
    createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    mrId: d['mrId'] as String? ?? '',
  );
}

Map<String, dynamic> expenseToFirestore(Expense e) => {
      'amount': e.amount,
      'date': Timestamp.fromDate(e.date),
      'category': e.category.index,
      'receiptImagePath': e.receiptImagePath,
      'isApproved': e.isApproved,
      'warningFlag': e.warningFlag,
      'createdAt': Timestamp.fromDate(e.createdAt),
      'mrId': e.mrId,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// Visit
// ---------------------------------------------------------------------------

Visit visitFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Visit(
    id: doc.id,
    doctorId: d['doctorId'] as String? ?? '',
    mrId: d['mrId'] as String? ?? '',
    visitDate: (d['visitDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    notes: d['notes'] as String? ?? '',
    outcome: d['outcome'] as String? ?? '',
    isCompleted: d['isCompleted'] as bool? ?? false,
  );
}

Map<String, dynamic> visitToFirestore(Visit v) => {
      'doctorId': v.doctorId,
      'mrId': v.mrId,
      'visitDate': Timestamp.fromDate(v.visitDate),
      'notes': v.notes,
      'outcome': v.outcome,
      'isCompleted': v.isCompleted,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// User
// ---------------------------------------------------------------------------

User userFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return User(
    id: doc.id,
    email: d['email'] as String? ?? '',
    name: d['name'] as String? ?? '',
    role: d['role'] as String? ?? 'mr',
    parentId: d['parentId'] as String? ?? '',
    territoryId: d['territoryId'] as String? ?? '',
    isActive: d['isActive'] as bool? ?? true,
    phone: d['phone'] as String? ?? '',
    profileImageUrl: d['profileImageUrl'] as String? ?? '',
    createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

Map<String, dynamic> userToFirestore(User u) => {
      'email': u.email,
      'name': u.name,
      'role': u.role,
      'parentId': u.parentId,
      'territoryId': u.territoryId,
      'isActive': u.isActive,
      'phone': u.phone,
      'profileImageUrl': u.profileImageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// Product
// ---------------------------------------------------------------------------

Product productFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Product(
    id: doc.id,
    name: d['name'] as String? ?? '',
    sku: d['sku'] as String? ?? '',
    category: d['category'] as String? ?? '',
    division: d['division'] as String? ?? '',
    price: (d['price'] as num?)?.toDouble() ?? 0.0,
    description: d['description'] as String? ?? '',
    imageUrl: d['imageUrl'] as String? ?? '',
    isActive: d['isActive'] as bool? ?? true,
  );
}

Map<String, dynamic> productToFirestore(Product p) => {
      'name': p.name,
      'sku': p.sku,
      'category': p.category,
      'division': p.division,
      'price': p.price,
      'description': p.description,
      'imageUrl': p.imageUrl,
      'isActive': p.isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// Territory
// ---------------------------------------------------------------------------

Territory territoryFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Territory(
    id: doc.id,
    name: d['name'] as String? ?? '',
    parentId: d['parentId'] as String? ?? '',
    level: d['level'] as int? ?? 0,
    boundaries: d['boundaries'] as String? ?? '{}',
  );
}

Map<String, dynamic> territoryToFirestore(Territory t) => {
      'name': t.name,
      'parentId': t.parentId,
      'level': t.level,
      'boundaries': t.boundaries,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// Order
// ---------------------------------------------------------------------------

Order orderFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Order(
    id: doc.id,
    mrId: d['mrId'] as String? ?? '',
    doctorId: d['doctorId'] as String? ?? '',
    status: OrderStatus
        .values[(d['status'] as int? ?? 0).clamp(0, OrderStatus.values.length - 1)],
    totalAmount: (d['totalAmount'] as num?)?.toDouble() ?? 0.0,
    orderDate: (d['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    deliveryDate: (d['deliveryDate'] as Timestamp?)?.toDate(),
    notes: d['notes'] as String? ?? '',
  );
}

Map<String, dynamic> orderToFirestore(Order o) => {
      'mrId': o.mrId,
      'doctorId': o.doctorId,
      'status': o.status.index,
      'totalAmount': o.totalAmount,
      'orderDate': Timestamp.fromDate(o.orderDate),
      'deliveryDate':
          o.deliveryDate != null ? Timestamp.fromDate(o.deliveryDate!) : null,
      'notes': o.notes,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// OrderItem
// ---------------------------------------------------------------------------

OrderItem orderItemFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return OrderItem(
    id: doc.id,
    orderId: d['orderId'] as String? ?? '',
    productId: d['productId'] as String? ?? '',
    quantity: d['quantity'] as int? ?? 0,
    price: (d['price'] as num?)?.toDouble() ?? 0.0,
    discount: (d['discount'] as num?)?.toDouble() ?? 0.0,
  );
}

Map<String, dynamic> orderItemToFirestore(OrderItem oi) => {
      'orderId': oi.orderId,
      'productId': oi.productId,
      'quantity': oi.quantity,
      'price': oi.price,
      'discount': oi.discount,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// TourPlan
// ---------------------------------------------------------------------------

TourPlan tourPlanFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return TourPlan(
    id: doc.id,
    mrId: d['mrId'] as String? ?? '',
    month: d['month'] as int? ?? 1,
    year: d['year'] as int? ?? DateTime.now().year,
    status: d['status'] as String? ?? 'draft',
    approvedBy: d['approvedBy'] as String? ?? '',
    submittedAt: (d['submittedAt'] as Timestamp?)?.toDate(),
    createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

Map<String, dynamic> tourPlanToFirestore(TourPlan tp) => {
      'mrId': tp.mrId,
      'month': tp.month,
      'year': tp.year,
      'status': tp.status,
      'approvedBy': tp.approvedBy,
      'submittedAt':
          tp.submittedAt != null ? Timestamp.fromDate(tp.submittedAt!) : null,
      'createdAt': Timestamp.fromDate(tp.createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// TourPlanDay
// ---------------------------------------------------------------------------

TourPlanDay tourPlanDayFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return TourPlanDay(
    id: doc.id,
    tourPlanId: d['tourPlanId'] as String? ?? '',
    date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    doctorIds: d['doctorIds'] as String? ?? '[]',
    notes: d['notes'] as String? ?? '',
    isCompleted: d['isCompleted'] as bool? ?? false,
  );
}

Map<String, dynamic> tourPlanDayToFirestore(TourPlanDay td) => {
      'tourPlanId': td.tourPlanId,
      'date': Timestamp.fromDate(td.date),
      'doctorIds': td.doctorIds,
      'notes': td.notes,
      'isCompleted': td.isCompleted,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// Attendance
// ---------------------------------------------------------------------------

Attendance attendanceFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Attendance(
    id: doc.id,
    mrId: d['mrId'] as String? ?? '',
    date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    punchInTime: (d['punchInTime'] as Timestamp?)?.toDate(),
    punchInLat: (d['punchInLat'] as num?)?.toDouble() ?? 0.0,
    punchInLng: (d['punchInLng'] as num?)?.toDouble() ?? 0.0,
    punchInSelfie: d['punchInSelfie'] as String? ?? '',
    punchOutTime: (d['punchOutTime'] as Timestamp?)?.toDate(),
    punchOutLat: (d['punchOutLat'] as num?)?.toDouble() ?? 0.0,
    punchOutLng: (d['punchOutLng'] as num?)?.toDouble() ?? 0.0,
    status: AttendanceStatus.values[
        (d['status'] as int? ?? 0).clamp(0, AttendanceStatus.values.length - 1)],
  );
}

Map<String, dynamic> attendanceToFirestore(Attendance a) => {
      'mrId': a.mrId,
      'date': Timestamp.fromDate(a.date),
      'punchInTime':
          a.punchInTime != null ? Timestamp.fromDate(a.punchInTime!) : null,
      'punchInLat': a.punchInLat,
      'punchInLng': a.punchInLng,
      'punchInSelfie': a.punchInSelfie,
      'punchOutTime':
          a.punchOutTime != null ? Timestamp.fromDate(a.punchOutTime!) : null,
      'punchOutLat': a.punchOutLat,
      'punchOutLng': a.punchOutLng,
      'status': a.status.index,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// LeaveRequest
// ---------------------------------------------------------------------------

LeaveRequest leaveRequestFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return LeaveRequest(
    id: doc.id,
    mrId: d['mrId'] as String? ?? '',
    leaveType: LeaveType.values[
        (d['leaveType'] as int? ?? 0).clamp(0, LeaveType.values.length - 1)],
    startDate: (d['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    endDate: (d['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    reason: d['reason'] as String? ?? '',
    status: ApprovalStatus.values[
        (d['status'] as int? ?? 0).clamp(0, ApprovalStatus.values.length - 1)],
    approvedBy: d['approvedBy'] as String? ?? '',
    comments: d['comments'] as String? ?? '',
  );
}

Map<String, dynamic> leaveRequestToFirestore(LeaveRequest lr) => {
      'mrId': lr.mrId,
      'leaveType': lr.leaveType.index,
      'startDate': Timestamp.fromDate(lr.startDate),
      'endDate': Timestamp.fromDate(lr.endDate),
      'reason': lr.reason,
      'status': lr.status.index,
      'approvedBy': lr.approvedBy,
      'comments': lr.comments,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// LeaveBalance
// ---------------------------------------------------------------------------

LeaveBalance leaveBalanceFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return LeaveBalance(
    id: doc.id,
    mrId: d['mrId'] as String? ?? '',
    leaveType: LeaveType.values[
        (d['leaveType'] as int? ?? 0).clamp(0, LeaveType.values.length - 1)],
    total: d['total'] as int? ?? 0,
    used: d['used'] as int? ?? 0,
    remaining: d['remaining'] as int? ?? 0,
    year: d['year'] as int? ?? DateTime.now().year,
  );
}

Map<String, dynamic> leaveBalanceToFirestore(LeaveBalance lb) => {
      'mrId': lb.mrId,
      'leaveType': lb.leaveType.index,
      'total': lb.total,
      'used': lb.used,
      'remaining': lb.remaining,
      'year': lb.year,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// Sample
// ---------------------------------------------------------------------------

Sample sampleFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Sample(
    id: doc.id,
    productId: d['productId'] as String? ?? '',
    mrId: d['mrId'] as String? ?? '',
    doctorId: d['doctorId'] as String? ?? '',
    quantity: d['quantity'] as int? ?? 0,
    date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    batchNo: d['batchNo'] as String? ?? '',
    expiryDate: (d['expiryDate'] as Timestamp?)?.toDate(),
    type: d['type'] as String? ?? 'sample',
  );
}

Map<String, dynamic> sampleToFirestore(Sample s) => {
      'productId': s.productId,
      'mrId': s.mrId,
      'doctorId': s.doctorId,
      'quantity': s.quantity,
      'date': Timestamp.fromDate(s.date),
      'batchNo': s.batchNo,
      'expiryDate':
          s.expiryDate != null ? Timestamp.fromDate(s.expiryDate!) : null,
      'type': s.type,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// StockLedger
// ---------------------------------------------------------------------------

StockLedger stockLedgerFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return StockLedger(
    id: doc.id,
    productId: d['productId'] as String? ?? '',
    mrId: d['mrId'] as String? ?? '',
    openingStock: d['openingStock'] as int? ?? 0,
    received: d['received'] as int? ?? 0,
    distributed: d['distributed'] as int? ?? 0,
    closingStock: d['closingStock'] as int? ?? 0,
    date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

Map<String, dynamic> stockLedgerToFirestore(StockLedger sl) => {
      'productId': sl.productId,
      'mrId': sl.mrId,
      'openingStock': sl.openingStock,
      'received': sl.received,
      'distributed': sl.distributed,
      'closingStock': sl.closingStock,
      'date': Timestamp.fromDate(sl.date),
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// Target
// ---------------------------------------------------------------------------

Target targetFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Target(
    id: doc.id,
    mrId: d['mrId'] as String? ?? '',
    productId: d['productId'] as String? ?? '',
    targetType: TargetType.values[
        (d['targetType'] as int? ?? 0).clamp(0, TargetType.values.length - 1)],
    targetValue: (d['targetValue'] as num?)?.toDouble() ?? 0.0,
    achievedValue: (d['achievedValue'] as num?)?.toDouble() ?? 0.0,
    period: d['period'] as String? ?? '',
  );
}

Map<String, dynamic> targetToFirestore(Target t) => {
      'mrId': t.mrId,
      'productId': t.productId,
      'targetType': t.targetType.index,
      'targetValue': t.targetValue,
      'achievedValue': t.achievedValue,
      'period': t.period,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// Approval
// ---------------------------------------------------------------------------

Approval approvalFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Approval(
    id: doc.id,
    type: ApprovalEntityType.values[
        (d['type'] as int? ?? 0).clamp(0, ApprovalEntityType.values.length - 1)],
    referenceId: d['referenceId'] as String? ?? '',
    requesterId: d['requesterId'] as String? ?? '',
    approverId: d['approverId'] as String? ?? '',
    status: ApprovalStatus.values[
        (d['status'] as int? ?? 0).clamp(0, ApprovalStatus.values.length - 1)],
    comments: d['comments'] as String? ?? '',
    createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

Map<String, dynamic> approvalToFirestore(Approval a) => {
      'type': a.type.index,
      'referenceId': a.referenceId,
      'requesterId': a.requesterId,
      'approverId': a.approverId,
      'status': a.status.index,
      'comments': a.comments,
      'createdAt': Timestamp.fromDate(a.createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// Notification
// ---------------------------------------------------------------------------

Notification notificationFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Notification(
    id: doc.id,
    userId: d['userId'] as String? ?? '',
    title: d['title'] as String? ?? '',
    body: d['body'] as String? ?? '',
    type: NotificationType.values[
        (d['type'] as int? ?? 4).clamp(0, NotificationType.values.length - 1)],
    referenceId: d['referenceId'] as String? ?? '',
    isRead: d['isRead'] as bool? ?? false,
    createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

Map<String, dynamic> notificationToFirestore(Notification n) => {
      'userId': n.userId,
      'title': n.title,
      'body': n.body,
      'type': n.type.index,
      'referenceId': n.referenceId,
      'isRead': n.isRead,
      'createdAt': Timestamp.fromDate(n.createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// Campaign
// ---------------------------------------------------------------------------

Campaign campaignFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return Campaign(
    id: doc.id,
    name: d['name'] as String? ?? '',
    startDate: (d['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    endDate: (d['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    description: d['description'] as String? ?? '',
    targetDoctors: d['targetDoctors'] as String? ?? '[]',
    status: d['status'] as String? ?? 'active',
  );
}

Map<String, dynamic> campaignToFirestore(Campaign c) => {
      'name': c.name,
      'startDate': Timestamp.fromDate(c.startDate),
      'endDate': Timestamp.fromDate(c.endDate),
      'description': c.description,
      'targetDoctors': c.targetDoctors,
      'status': c.status,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// EDetailContent
// ---------------------------------------------------------------------------

EDetailContent eDetailContentFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return EDetailContent(
    id: doc.id,
    productId: d['productId'] as String? ?? '',
    title: d['title'] as String? ?? '',
    type: d['type'] as String? ?? 'pdf',
    url: d['url'] as String? ?? '',
    version: d['version'] as String? ?? '1.0',
    isActive: d['isActive'] as bool? ?? true,
  );
}

Map<String, dynamic> eDetailContentToFirestore(EDetailContent e) => {
      'productId': e.productId,
      'title': e.title,
      'type': e.type,
      'url': e.url,
      'version': e.version,
      'isActive': e.isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    };

// ---------------------------------------------------------------------------
// ActivityLog
// ---------------------------------------------------------------------------

ActivityLog activityLogFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc) {
  final d = doc.data()!;
  return ActivityLog(
    id: doc.id,
    userId: d['userId'] as String? ?? '',
    action: d['action'] as String? ?? '',
    entityType: d['entityType'] as String? ?? '',
    entityId: d['entityId'] as String? ?? '',
    details: d['details'] as String? ?? '',
    timestamp: (d['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

Map<String, dynamic> activityLogToFirestore(ActivityLog a) => {
      'userId': a.userId,
      'action': a.action,
      'entityType': a.entityType,
      'entityId': a.entityId,
      'details': a.details,
      'timestamp': Timestamp.fromDate(a.timestamp),
      'updatedAt': FieldValue.serverTimestamp(),
    };
