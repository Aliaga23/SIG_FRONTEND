import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;
  final Widget? trailing;

  const OrderCard({
    Key? key,
    required this.order,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: _buildStatusIcon(),
        title: Text(
          order.customerName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.customerAddress,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.monetization_on, size: 16, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  'Bs. ${order.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 16),
                Icon(Icons.payment, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(order.paymentMethod),
              ],
            ),
          ],
        ),
        trailing: trailing ?? Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (order.status) {
      case OrderStatus.pending:
        icon = Icons.access_time;
        color = Colors.orange;
        break;
      case OrderStatus.inTransit:
        icon = Icons.local_shipping;
        color = Colors.blue;
        break;
      case OrderStatus.delivered:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case OrderStatus.failed:
        icon = Icons.error;
        color = Colors.red;
        break;
      case OrderStatus.cancelled:
        icon = Icons.cancel;
        color = Colors.grey;
        break;
    }

    return CircleAvatar(
      backgroundColor: color,
      child: Icon(icon, color: Colors.white),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final OrderStatus status;
  final double? fontSize;

  const StatusBadge({
    Key? key,
    required this.status,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    switch (status) {
      case OrderStatus.pending:
        text = 'Pendiente';
        color = Colors.orange;
        break;
      case OrderStatus.inTransit:
        text = 'En tránsito';
        color = Colors.blue;
        break;
      case OrderStatus.delivered:
        text = 'Entregado';
        color = Colors.green;
        break;
      case OrderStatus.failed:
        text = 'Fallido';
        color = Colors.red;
        break;
      case OrderStatus.cancelled:
        text = 'Cancelado';
        color = Colors.grey;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.blue[600],
      foregroundColor: Colors.white,
      elevation: 0,
      actions: actions,
      automaticallyImplyLeading: showBackButton,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final Widget? action;

  const EmptyState({
    Key? key,
    required this.message,
    required this.icon,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            SizedBox(height: 16),
            action!,
          ],
        ],
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
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
      ),
    );
  }
}
