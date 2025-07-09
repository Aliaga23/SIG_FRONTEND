import 'package:flutter/foundation.dart';
import '../models/order.dart';

class DeliveryProvider with ChangeNotifier {
  List<Order> _orders = [];
  Order? _selectedOrder;
  bool _isLoading = false;

  List<Order> get orders => _orders;
  Order? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;

  List<Order> get pendingOrders => _orders.where((order) => order.status == OrderStatus.pending).toList();
  List<Order> get inTransitOrders => _orders.where((order) => order.status == OrderStatus.inTransit).toList();
  List<Order> get deliveredOrders => _orders.where((order) => order.status == OrderStatus.delivered).toList();

  DeliveryProvider() {
    _loadSimulatedData();
  }

  void _loadSimulatedData() {
    _orders = [
      Order(
        id: '001',
        customerName: 'Ana García',
        customerPhone: '+591 70123456',
        customerAddress: 'Av. San Martín #2345, Edificio Torre Azul, Piso 5, Centro',
        latitude: -17.7800,
        longitude: -63.1800,
        items: [
          ShoeItem(
            id: '1',
            name: 'Zapatillas Nike Air Max',
            brand: 'Nike',
            size: '38',
            color: 'Negro',
            price: 450.0,
            quantity: 1,
            imageUrl: 'https://via.placeholder.com/150',
          ),
        ],
        totalAmount: 450.0,
        paymentMethod: 'QR',
        status: OrderStatus.pending,
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
      ),
      Order(
        id: '002',
        customerName: 'Carlos Mendoza',
        customerPhone: '+591 75987654',
        customerAddress: 'Av. Cristo Redentor #1234, Equipetrol, Santa Cruz',
        latitude: -17.7900,
        longitude: -63.1700,
        items: [
          ShoeItem(
            id: '2',
            name: 'Zapatos Adidas Ultraboost',
            brand: 'Adidas',
            size: '42',
            color: 'Blanco',
            price: 380.0,
            quantity: 1,
            imageUrl: 'https://via.placeholder.com/150',
          ),
        ],
        totalAmount: 380.0,
        paymentMethod: 'Transferencia',
        status: OrderStatus.pending,
        createdAt: DateTime.now().subtract(Duration(hours: 1)),
      ),
      Order(
        id: '003',
        customerName: 'María López',
        customerPhone: '+591 78456123',
        customerAddress: 'Av. Banzer #5678, Edificio San Martín, Plan 3000',
        latitude: -17.7700,
        longitude: -63.1900,
        items: [
          ShoeItem(
            id: '3',
            name: 'Botas Timberland',
            brand: 'Timberland',
            size: '37',
            color: 'Marrón',
            price: 520.0,
            quantity: 1,
            imageUrl: 'https://via.placeholder.com/150',
          ),
        ],
        totalAmount: 520.0,
        paymentMethod: 'Efectivo',
        status: OrderStatus.inTransit,
        createdAt: DateTime.now().subtract(Duration(hours: 3)),
      ),
      Order(
        id: '004',
        customerName: 'José Rivera',
        customerPhone: '+591 71234567',
        customerAddress: 'Calle Libertad #987, Zona Centro, Santa Cruz',
        latitude: -17.7850,
        longitude: -63.1850,
        items: [
          ShoeItem(
            id: '4',
            name: 'Converse Chuck Taylor',
            brand: 'Converse',
            size: '40',
            color: 'Rojo',
            price: 280.0,
            quantity: 2,
            imageUrl: 'https://via.placeholder.com/150',
          ),
        ],
        totalAmount: 560.0,
        paymentMethod: 'QR',
        status: OrderStatus.delivered,
        createdAt: DateTime.now().subtract(Duration(hours: 5)),
        deliveredAt: DateTime.now().subtract(Duration(hours: 1)),
        observations: 'Entregado correctamente',
      ),
      Order(
        id: '005',
        customerName: 'Laura Fernández',
        customerPhone: '+591 76543210',
        customerAddress: 'Av. Alemana #456, Barrio Las Palmas, Santa Cruz',
        latitude: -17.7950,
        longitude: -63.1750,
        items: [
          ShoeItem(
            id: '5',
            name: 'Puma Suede Classic',
            brand: 'Puma',
            size: '36',
            color: 'Azul',
            price: 320.0,
            quantity: 1,
            imageUrl: 'https://via.placeholder.com/150',
          ),
        ],
        totalAmount: 320.0,
        paymentMethod: 'Transferencia',
        status: OrderStatus.pending,
        createdAt: DateTime.now().subtract(Duration(minutes: 30)),
      ),
      Order(
        id: '006',
        customerName: 'Pedro Mamani',
        customerPhone: '+591 72345678',
        customerAddress: 'Av. Roca y Coronado #789, Centro, Santa Cruz',
        latitude: -17.7820,
        longitude: -63.1880,
        items: [
          ShoeItem(
            id: '6',
            name: 'Vans Old Skool',
            brand: 'Vans',
            size: '41',
            color: 'Negro/Blanco',
            price: 290.0,
            quantity: 1,
            imageUrl: 'https://via.placeholder.com/150',
          ),
        ],
        totalAmount: 290.0,
        paymentMethod: 'Efectivo',
        status: OrderStatus.pending,
        createdAt: DateTime.now().subtract(Duration(minutes: 45)),
      ),
    ];
    notifyListeners();
  }

  void selectOrder(Order order) {
    _selectedOrder = order;
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus, {String? observations}) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        status: newStatus,
        deliveredAt: newStatus == OrderStatus.delivered ? DateTime.now() : null,
        observations: observations,
      );
      notifyListeners();
    }
  }

  void startDelivery(String orderId) {
    updateOrderStatus(orderId, OrderStatus.inTransit);
  }

  void completeDelivery(String orderId, String observations) {
    updateOrderStatus(orderId, OrderStatus.delivered, observations: observations);
  }

  void failDelivery(String orderId, String observations) {
    updateOrderStatus(orderId, OrderStatus.failed, observations: observations);
  }

  double get totalEarnings {
    return _orders
        .where((order) => order.status == OrderStatus.delivered)
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  int get deliveredCount {
    return _orders.where((order) => order.status == OrderStatus.delivered).length;
  }

  int get pendingCount {
    return _orders.where((order) => order.status == OrderStatus.pending).length;
  }
}
