# SIG Shoes - Aplicación de Distribución de Zapatos

## Descripción

SIG Shoes es una aplicación móvil Flutter completa para la gestión y optimización de la distribución de zapatos. Integra funcionalidades avanzadas de backend para el manejo de distribuidores, vehículos, pedidos, pagos, rutas, entregas y asignaciones en tiempo real.

## Características Principales

### 🚀 Funcionalidades Implementadas

#### Autenticación y Gestión de Usuarios
- Sistema de login seguro con JWT
- Gestión de distribuidores con información completa
- Manejo de sesiones y tokens

#### Dashboard Inteligente
- Estadísticas en tiempo real
- Seguimiento de pedidos (asignados, en camino, entregados)
- Control de tracking GPS
- Información del vehículo asignado
- Resumen de rutas y entregas

#### Gestión de Pedidos
- Lista de pedidos con diferentes estados
- Detalles completos de cada pedido
- Acciones rápidas (entregar, pagar, ver detalles)
- Actualización de estado en tiempo real

#### Sistema de Asignaciones
- **Asignación automática**: Algoritmo inteligente que asigna pedidos basándose en:
  - Capacidad del vehículo
  - Proximidad geográfica
  - Optimización de rutas
- **Gestión de asignaciones**: Visualización y control de asignaciones activas
- **Integración con vehículos**: Asociación automática con vehículos asignados

#### Gestión de Entregas
- Formulario de entrega con observaciones
- Captura de ubicación en tiempo real
- Estados de entrega (entregado, no entregado, producto incorrecto)
- Motivos de no entrega
- Historial de entregas

#### Sistema de Pagos
- Múltiples métodos de pago:
  - Código QR
  - Transferencia bancaria
  - Efectivo
- Generación automática de códigos QR
- Registro de transacciones
- Integración con servicios de pago

#### Seguimiento y Navegación
- Tracking GPS en tiempo real
- Mapas integrados con Google Maps
- Optimización de rutas
- Navegación paso a paso

#### Modelos de Datos Completos
- **Distribuidor**: Información completa con vehículo asignado
- **Vehículo**: Marca, modelo, placa, capacidad, tipo
- **Pedido**: Cliente, productos, detalles, estado, total
- **Producto**: Nombre, descripción, precio, talla, color, stock
- **Cliente**: Información personal, dirección, coordenadas
- **Asignación**: Gestión de pedidos asignados a distribuidores
- **Ruta de Entrega**: Coordenadas, distancia, tiempo estimado
- **Entrega**: Estado, observaciones, ubicación final

### 🛠️ Arquitectura y Servicios

#### Servicios Implementados
- **ApiService**: Comunicación con el backend
- **AuthService**: Autenticación y manejo de sesiones
- **PedidoService**: Gestión de pedidos
- **VehiculoService**: Manejo de vehículos
- **AsignacionService**: Asignaciones de entrega
- **AsignacionVehiculoService**: Asignaciones de vehículos
- **RutaEntregaService**: Gestión de rutas y entregas
- **ProductoService**: Gestión de productos
- **ClienteService**: Gestión de clientes
- **PagoService**: Procesamiento de pagos
- **TrackingService**: Seguimiento GPS
- **AppService**: Servicio centralizado para funcionalidades complejas

#### Providers (Estado Global)
- **AuthProvider**: Estado de autenticación
- **PedidoProvider**: Estado de pedidos

#### Estructura de Navegación
- **Dashboard**: Página principal con estadísticas
- **Pedidos**: Gestión de pedidos
- **Asignaciones**: Gestión de asignaciones automáticas y manuales
- **Entregas**: Formularios y seguimiento de entregas
- **Pagos**: Procesamiento de pagos
- **Mapa**: Navegación y rutas

## Instalación

### Prerrequisitos
- Flutter SDK 3.0 o superior
- Android Studio / VS Code
- Dispositivo Android o emulador
- Conexión a internet

### Dependencias Principales
```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.0.0
  provider: ^6.0.0
  geolocator: ^9.0.0
  google_maps_flutter: ^2.2.0
  qr_flutter: ^4.0.0
  qr_code_scanner: ^1.0.0
  shared_preferences: ^2.0.0
  permission_handler: ^10.0.0
  url_launcher: ^6.0.0
```

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/usuario/sig_shoes.git
cd sig_shoes
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar el backend**
   - Asegúrate de que el backend esté corriendo
   - Actualiza la URL en `lib/core/constants/api.dart`

4. **Ejecutar la aplicación**
```bash
flutter run
```

## Configuración del Backend

La aplicación se conecta al backend SIG_Backend que debe estar configurado y ejecutándose. 

### Endpoints Utilizados

#### Autenticación
- `POST /auth/login`: Inicio de sesión
- `GET /auth/profile`: Perfil del usuario

#### Distribuidores
- `GET /distribuidores/`: Lista de distribuidores
- `POST /distribuidores/`: Crear distribuidor
- `GET /distribuidores/{id}`: Obtener distribuidor
- `PUT /distribuidores/{id}`: Actualizar distribuidor

#### Vehículos
- `GET /vehiculos/`: Lista de vehículos
- `POST /vehiculos/`: Crear vehículo
- `GET /vehiculos/{id}`: Obtener vehículo

#### Pedidos
- `GET /pedidos/`: Lista de pedidos
- `POST /pedidos/`: Crear pedido
- `PATCH /pedidos/{id}/estado`: Actualizar estado

#### Asignaciones
- `POST /asignaciones-entrega/asignar-automaticamente/{distribuidor_id}`: Asignación automática
- `GET /asignaciones-entrega/`: Lista de asignaciones
- `POST /asignaciones-entrega/`: Crear asignación

#### Rutas y Entregas
- `GET /rutas-entrega/`: Lista de rutas
- `POST /rutas-entrega/entregas`: Registrar entrega
- `PATCH /rutas-entrega/entregas/{id}/estado`: Actualizar estado

#### Pagos
- `POST /pagos/`: Registrar pago
- `GET /pagos/stripe/create-session/{pedido_id}`: Crear sesión de pago

## Uso de la Aplicación

### Login
1. Ingresa tu email y contraseña
2. La aplicación autentica con el backend
3. Accede al dashboard principal

### Dashboard
- Visualiza estadísticas en tiempo real
- Controla el tracking GPS
- Ve información de tu vehículo asignado
- Accede a acciones rápidas

### Gestión de Pedidos
- Ve todos los pedidos asignados
- Cambia estados de pedidos
- Accede a detalles completos
- Navega a la ubicación del cliente

### Asignaciones Automáticas
1. Ve a la pestaña "Asignaciones"
2. Verifica que tengas un vehículo asignado
3. Presiona "Realizar Asignación Automática"
4. El sistema asigna pedidos optimizados

### Proceso de Entrega
1. Selecciona un pedido
2. Presiona "Entregar"
3. Llena el formulario de entrega
4. Confirma la entrega con observaciones

### Procesamiento de Pagos
1. Selecciona método de pago
2. Para QR: Se genera automáticamente
3. Para transferencia: Proporciona detalles
4. Para efectivo: Confirma el monto

## Arquitectura del Proyecto

```
lib/
├── core/
│   ├── constants/
│   ├── utils/
│   └── widgets/
├── models/
│   ├── distribuidor.dart
│   ├── vehiculo.dart
│   ├── pedido.dart
│   ├── producto.dart
│   ├── cliente.dart
│   ├── asignacion_entrega.dart
│   └── ruta_entrega.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── pedido_service.dart
│   ├── vehiculo_service.dart
│   ├── asignacion_service.dart
│   ├── ruta_entrega_service.dart
│   ├── pago_service.dart
│   ├── tracking_service.dart
│   └── app_service.dart
├── providers/
│   ├── auth_provider.dart
│   └── pedido_provider.dart
├── views/
│   ├── dashboard/
│   ├── pedidos/
│   ├── asignaciones/
│   ├── entrega/
│   ├── pago/
│   └── mapa/
└── config/
    └── router.dart
```

## Próximas Mejoras

### Funcionalidades Pendientes
- [ ] Notificaciones push
- [ ] Modo offline
- [ ] Sincronización automática
- [ ] Reportes avanzados
- [ ] Gestión de inventario
- [ ] Chat con clientes
- [ ] Análisis de rendimiento

### Optimizaciones Técnicas
- [ ] Caché inteligente
- [ ] Optimización de imágenes
- [ ] Reducción del tamaño de la app
- [ ] Mejoras en el rendimiento

