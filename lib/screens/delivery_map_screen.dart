import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/delivery_provider.dart';
import '../models/order.dart';

class DeliveryMapScreen extends StatefulWidget {
  @override
  _DeliveryMapScreenState createState() => _DeliveryMapScreenState();
}

class _DeliveryMapScreenState extends State<DeliveryMapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  
  // Ubicación central de Santa Cruz de la Sierra, Bolivia
  static const CameraPosition _kSantaCruz = CameraPosition(
    target: LatLng(-17.7837, -63.1821),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DeliveryProvider>(
        builder: (context, deliveryProvider, child) {
          _updateMarkers(deliveryProvider.orders);
          
          return Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kSantaCruz,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                markers: markers,
              ),
              _buildMapControls(deliveryProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMapControls(DeliveryProvider deliveryProvider) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem(Colors.orange, 'Pendientes', deliveryProvider.pendingCount),
                  _buildLegendItem(Colors.blue, 'En tránsito', deliveryProvider.inTransitOrders.length),
                  _buildLegendItem(Colors.green, 'Entregados', deliveryProvider.deliveredCount),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _centerMap(),
                      icon: Icon(Icons.center_focus_strong),
                      label: Text('Centrar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showOptimalRoute(deliveryProvider),
                      icon: Icon(Icons.route),
                      label: Text('Ruta óptima'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, int count) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _updateMarkers(List<Order> orders) {
    markers.clear();
    
    for (Order order in orders) {
      BitmapDescriptor icon;
      
      switch (order.status) {
        case OrderStatus.pending:
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
          break;
        case OrderStatus.inTransit:
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
          break;
        case OrderStatus.delivered:
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
          break;
        case OrderStatus.failed:
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          break;
        case OrderStatus.cancelled:
          icon = BitmapDescriptor.defaultMarker;
          break;
      }

      markers.add(
        Marker(
          markerId: MarkerId(order.id),
          position: LatLng(order.latitude, order.longitude),
          icon: icon,
          infoWindow: InfoWindow(
            title: order.customerName,
            snippet: '${order.customerAddress}\nBs. ${order.totalAmount.toStringAsFixed(2)}',
          ),
          onTap: () => _showOrderBottomSheet(order),
        ),
      );
    }
  }

  void _centerMap() {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(_kSantaCruz),
      );
    }
  }

  void _showOptimalRoute(DeliveryProvider deliveryProvider) {
    final pendingOrders = deliveryProvider.pendingOrders;
    if (pendingOrders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No hay pedidos pendientes para calcular la ruta'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Aquí se implementaría el algoritmo de ruta óptima
    // Por ahora, mostramos un mensaje simulado
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ruta óptima calculada'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ruta sugerida para ${pendingOrders.length} entregas:'),
              SizedBox(height: 16),
              ...pendingOrders.asMap().entries.map((entry) {
                int index = entry.key;
                Order order = entry.value;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(order.customerName),
                  subtitle: Text(order.customerAddress),
                  trailing: Text('Bs. ${order.totalAmount.toStringAsFixed(2)}'),
                );
              }).toList(),
              SizedBox(height: 16),
              Text(
                'Tiempo estimado: ${pendingOrders.length * 15} minutos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _startOptimalRoute(pendingOrders);
              },
              child: Text('Iniciar ruta'),
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

  void _startOptimalRoute(List<Order> orders) {
    // Simular el inicio de la ruta marcando el primer pedido como en tránsito
    if (orders.isNotEmpty) {
      Provider.of<DeliveryProvider>(context, listen: false)
          .startDelivery(orders.first.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ruta iniciada. Dirigiéndose a ${orders.first.customerName}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showOrderBottomSheet(Order order) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    order.status == OrderStatus.pending 
                        ? Icons.access_time 
                        : order.status == OrderStatus.inTransit 
                            ? Icons.local_shipping 
                            : Icons.check_circle,
                    color: order.status == OrderStatus.pending 
                        ? Colors.orange 
                        : order.status == OrderStatus.inTransit 
                            ? Colors.blue 
                            : Colors.green,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.customerName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                order.customerAddress,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: Bs. ${order.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'Pago: ${order.paymentMethod}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _openInMaps(order);
                      },
                      icon: Icon(Icons.navigation),
                      label: Text('Navegar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _callCustomer(order.customerPhone);
                      },
                      icon: Icon(Icons.phone),
                      label: Text('Llamar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _openInMaps(Order order) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${order.latitude},${order.longitude}';
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback: mostrar mensaje si no se puede abrir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo abrir la navegación a ${order.customerName}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _callCustomer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo realizar la llamada a $phoneNumber'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
