class Order {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final double latitude;
  final double longitude;
  final List<ShoeItem> items;
  final double totalAmount;
  final String paymentMethod; // QR, Transfer, Cash
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String? observations;

  Order({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.latitude,
    required this.longitude,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.deliveredAt,
    this.observations,
  });

  Order copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    double? latitude,
    double? longitude,
    List<ShoeItem>? items,
    double? totalAmount,
    String? paymentMethod,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? deliveredAt,
    String? observations,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      observations: observations ?? this.observations,
    );
  }
}

class ShoeItem {
  final String id;
  final String name;
  final String brand;
  final String size;
  final String color;
  final double price;
  final int quantity;
  final String imageUrl;

  ShoeItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.size,
    required this.color,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

enum OrderStatus {
  pending,
  inTransit,
  delivered,
  failed,
  cancelled
}

class Distributor {
  final String id;
  final String name;
  final String phone;
  final String vehicleType;
  final String vehiclePlate;
  final double capacity;
  final bool isActive;

  Distributor({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.capacity,
    required this.isActive,
  });
}

enum PaymentMethod {
  qr,
  transfer,
  cash
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.qr:
        return 'QR';
      case PaymentMethod.transfer:
        return 'Transferencia';
      case PaymentMethod.cash:
        return 'Efectivo';
    }
  }
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.inTransit:
        return 'En tránsito';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.failed:
        return 'Falló';
      case OrderStatus.cancelled:
        return 'Cancelado';
    }
  }
}
