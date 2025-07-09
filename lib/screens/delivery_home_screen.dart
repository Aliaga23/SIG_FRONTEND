import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/delivery_provider.dart';
import '../models/order.dart';
import 'order_details_screen.dart';
import 'delivery_map_screen.dart';

class DeliveryHomeScreen extends StatefulWidget {
  @override
  _DeliveryHomeScreenState createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    OrdersListScreen(),
    DeliveryMapScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIG Shoes - Repartidor'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh data - simulate refresh
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Datos actualizados')),
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Estadísticas',
          ),
        ],
      ),
    );
  }
}

class OrdersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, deliveryProvider, child) {
        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                color: Colors.blue[50],
                child: TabBar(
                  labelColor: Colors.blue[600],
                  indicatorColor: Colors.blue[600],
                  tabs: [
                    Tab(text: 'Pendientes (${deliveryProvider.pendingCount})'),
                    Tab(text: 'En tránsito'),
                    Tab(text: 'Entregados'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildOrdersList(deliveryProvider.pendingOrders, context),
                    _buildOrdersList(deliveryProvider.inTransitOrders, context),
                    _buildOrdersList(deliveryProvider.deliveredOrders, context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrdersList(List<Order> orders, BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay pedidos',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: order.status == OrderStatus.pending 
                  ? Colors.orange 
                  : order.status == OrderStatus.inTransit 
                      ? Colors.blue 
                      : Colors.green,
              child: Icon(
                order.status == OrderStatus.pending 
                    ? Icons.access_time 
                    : order.status == OrderStatus.inTransit 
                        ? Icons.local_shipping 
                        : Icons.check,
                color: Colors.white,
              ),
            ),
            title: Text(
              order.customerName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.customerAddress),
                SizedBox(height: 4),
                Text(
                  'Bs. ${order.totalAmount.toStringAsFixed(2)} - ${order.paymentMethod}',
                  style: TextStyle(
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: order.status == OrderStatus.pending
                ? ElevatedButton(
                    onPressed: () => _startDelivery(context, order),
                    child: Text('Iniciar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  )
                : Icon(Icons.chevron_right),
            onTap: () => _showOrderDetails(context, order),
          ),
        );
      },
    );
  }

  void _startDelivery(BuildContext context, Order order) {
    Provider.of<DeliveryProvider>(context, listen: false).startDelivery(order.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Entrega iniciada para ${order.customerName}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(order: order),
      ),
    );
  }
}

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, deliveryProvider, child) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estadísticas del día',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Entregas realizadas',
                      '${deliveryProvider.deliveredCount}',
                      Colors.green,
                      Icons.check_circle,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Pedidos pendientes',
                      '${deliveryProvider.pendingCount}',
                      Colors.orange,
                      Icons.pending,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildStatCard(
                'Ganancias del día',
                'Bs. ${deliveryProvider.totalEarnings.toStringAsFixed(2)}',
                Colors.blue,
                Icons.monetization_on,
              ),
              SizedBox(height: 20),
              Text(
                'Entregas recientes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: deliveryProvider.deliveredOrders.length,
                  itemBuilder: (context, index) {
                    final order = deliveryProvider.deliveredOrders[index];
                    return ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text(order.customerName),
                      subtitle: Text('Bs. ${order.totalAmount.toStringAsFixed(2)}'),
                      trailing: Text(
                        order.deliveredAt != null
                            ? '${order.deliveredAt!.hour}:${order.deliveredAt!.minute.toString().padLeft(2, '0')}'
                            : '',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
