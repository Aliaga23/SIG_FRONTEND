import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order.dart';
import '../providers/delivery_provider.dart';
import 'payment_qr_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido #${order.id}'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            SizedBox(height: 16),
            _buildCustomerInfo(),
            SizedBox(height: 16),
            _buildItemsList(),
            SizedBox(height: 16),
            _buildPaymentInfo(context),
            SizedBox(height: 16),
            _buildDeliveryActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado del pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Spacer(),
                Text(
                  'Creado: ${_formatDateTime(order.createdAt)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            if (order.deliveredAt != null) ...[
              SizedBox(height: 8),
              Text(
                'Entregado: ${_formatDateTime(order.deliveredAt!)}',
                style: TextStyle(color: Colors.green[600], fontSize: 12),
              ),
            ],
            if (order.observations != null) ...[
              SizedBox(height: 8),
              Text(
                'Observaciones: ${order.observations}',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información del cliente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue[600]),
                SizedBox(width: 8),
                Text(
                  order.customerName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue[600]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(order.customerPhone),
                ),
                IconButton(
                  icon: Icon(Icons.call, color: Colors.green),
                  onPressed: () => _makePhoneCall(order.customerPhone),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Colors.blue[600]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(order.customerAddress),
                ),
                IconButton(
                  icon: Icon(Icons.map, color: Colors.blue),
                  onPressed: () => _openMap(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ...order.items.map((item) => _buildItemRow(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(ShoeItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.shopping_bag, color: Colors.grey[600]),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${item.brand} - Talla ${item.size} - ${item.color}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Text(
                  'Cantidad: ${item.quantity}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            'Bs. ${(item.price * item.quantity).toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información de pago',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.payment, color: Colors.blue[600]),
                SizedBox(width: 8),
                Text('Método de pago: ${order.paymentMethod}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.green[600]),
                SizedBox(width: 8),
                Text(
                  'Total: Bs. ${order.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
            if (order.paymentMethod == 'QR') ...[
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _showQRPayment(context),
                icon: Icon(Icons.qr_code),
                label: Text('Mostrar QR de Pago'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryActions(BuildContext context) {
    if (order.status == OrderStatus.delivered) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 48),
              SizedBox(height: 8),
              Text(
                'Pedido entregado exitosamente',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Acciones de entrega',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            if (order.status == OrderStatus.pending) ...[
              ElevatedButton.icon(
                onPressed: () => _startDelivery(context),
                icon: Icon(Icons.play_arrow),
                label: Text('Iniciar entrega'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
            if (order.status == OrderStatus.inTransit) ...[
              ElevatedButton.icon(
                onPressed: () => _showCompleteDialog(context),
                icon: Icon(Icons.check),
                label: Text('Marcar como entregado'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _showFailDialog(context),
                icon: Icon(Icons.error),
                label: Text('Marcar como fallido'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.inTransit:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.failed:
        return Colors.red;
      case OrderStatus.cancelled:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (order.status) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.inTransit:
        return 'En tránsito';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.failed:
        return 'Fallido';
      case OrderStatus.cancelled:
        return 'Cancelado';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void _openMap() async {
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      query: 'api=1&query=${order.latitude},${order.longitude}',
    );
    await launchUrl(launchUri);
  }

  void _startDelivery(BuildContext context) {
    Provider.of<DeliveryProvider>(context, listen: false).startDelivery(order.id);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Entrega iniciada'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showCompleteDialog(BuildContext context) {
    final TextEditingController observationsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar entrega'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¿Estás seguro de que quieres marcar este pedido como entregado?'),
              SizedBox(height: 16),
              TextField(
                controller: observationsController,
                decoration: InputDecoration(
                  labelText: 'Observaciones',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<DeliveryProvider>(context, listen: false)
                    .completeDelivery(order.id, observationsController.text);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close details screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pedido marcado como entregado'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Confirmar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFailDialog(BuildContext context) {
    final TextEditingController observationsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Marcar como fallido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¿Por qué no se pudo entregar el pedido?'),
              SizedBox(height: 16),
              TextField(
                controller: observationsController,
                decoration: InputDecoration(
                  labelText: 'Motivo del fallo',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<DeliveryProvider>(context, listen: false)
                    .failDelivery(order.id, observationsController.text);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close details screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pedido marcado como fallido'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Text('Confirmar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showQRPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentQRScreen(order: order),
      ),
    );
  }
}
