import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../converters/firestore_converters.dart';
import '../models/database.dart';
import 'base_repository.dart';

class OrderRepository extends BaseRepository {
  OrderRepository(super.db);

  Stream<List<Order>> watchForMr(String mrId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('mrId', isEqualTo: mrId)
          .orderBy('orderDate', descending: true)
          .snapshots()
          .map((s) => s.docs.map<Order>((d) => orderFromFirestore(d)).toList());
    }
    return (db.select(db.orders)
          ..where((t) => t.mrId.equals(mrId))
          ..orderBy([(t) => OrderingTerm.desc(t.orderDate)]))
        .watch();
  }

  Future<Order?> getById(String id) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('orders')
          .doc(id)
          .get()
          .then((d) => d.exists ? orderFromFirestore(d) : null);
    }
    return (db.select(db.orders)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<List<OrderItem>> watchItems(String orderId) {
    if (kIsWeb) {
      return FirebaseFirestore.instance
          .collection('orderItems')
          .where('orderId', isEqualTo: orderId)
          .snapshots()
          .map((s) => s.docs.map(orderItemFromFirestore).toList());
    }
    return (db.select(db.orderItems)
          ..where((t) => t.orderId.equals(orderId)))
        .watch();
  }

  Future<void> createOrder(OrdersCompanion order, List<OrderItemsCompanion> items) async {
    if (kIsWeb) {
      final fs = FirebaseFirestore.instance;
      await fs.collection('orders').doc(order.id.value).set({
        'id': order.id.value,
        'mrId': order.mrId.value,
        'doctorId': order.doctorId.value,
        'status': order.status.value.index,
        'totalAmount': order.totalAmount.value,
        'orderDate': Timestamp.fromDate(order.orderDate.value),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      for (final item in items) {
        await fs.collection('orderItems').doc(item.id.value).set({
          'id': item.id.value,
          'orderId': item.orderId.value,
          'productId': item.productId.value,
          'quantity': item.quantity.value,
          'price': item.price.value,
          'discount': item.discount.value,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      return;
    }

    await db.into(db.orders).insertOnConflictUpdate(order);
    for (final item in items) {
      await db.into(db.orderItems).insertOnConflictUpdate(item);
    }
    await enqueueSync(
      collectionName: 'orders',
      documentId: order.id.value,
      opType: OperationType.create,
      payload: jsonEncode({
        'id': order.id.value,
        'mrId': order.mrId.value,
        'doctorId': order.doctorId.value,
        'status': order.status.value.index,
        'totalAmount': order.totalAmount.value,
        'orderDate': order.orderDate.value.toIso8601String(),
        'items': items.map((i) => {
              'id': i.id.value,
              'productId': i.productId.value,
              'quantity': i.quantity.value,
              'price': i.price.value,
              'discount': i.discount.value,
            }).toList(),
      }),
    );
  }

  Future<void> updateStatus(String id, OrderStatus status) async {
    if (kIsWeb) {
      await FirebaseFirestore.instance.collection('orders').doc(id).update({
        'status': status.index,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    await (db.update(db.orders)..where((t) => t.id.equals(id))).write(
      OrdersCompanion(status: Value(status)),
    );
    await enqueueSync(
      collectionName: 'orders',
      documentId: id,
      opType: OperationType.update,
      payload: jsonEncode({'id': id, 'status': status.index}),
    );
  }
}
