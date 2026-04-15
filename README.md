# BTG - Manejo de Fondos (FPV/FIC) 🏦

Esta es una aplicación interactiva y responsiva desarrollada en **Flutter** para el manejo de fondos de inversión, cumpliendo con los requerimientos técnicos y funcionales de la prueba para Ingeniero de Desarrollo Front-End.

---

## 🛠️ Requisitos de Instalación

Antes de comenzar, asegúrate de tener instalado:
- **Flutter SDK** (^3.11.0)
- **Dart SDK** (^3.0.0)

### Pasos Iniciales 🚀

1. **Clonar el repositorio:**
   ```sh
   git clone <url-del-repositorio>
   cd btg
   ```

2. **Obtener dependencias:**
   ```sh
   flutter pub get
   ```

3. **Generación de Código (CRÍTICO) ⚙️:**
   Este proyecto utiliza `injectable` para la inyección de dependencias. **Debes ejecutar el siguiente comando** para generar los archivos necesarios:
   ```sh
   # Generar archivos de inyección de dependencias
   dart run build_runner build --delete-conflicting-outputs
   ```

---

## 🏃 Ejecución del Proyecto

El proyecto está configurado con **Flavors**. Para ejecutarlo en tu dispositivo o simulador:

```sh
# Ejecución en modo desarrollo (Recomendado)
flutter run --flavor development --target lib/main_development.dart
```

---

## 🏗️ Arquitectura y Tecnologías

El proyecto sigue los principios de **Clean Architecture** y **SOLID** para garantizar escalabilidad y mantenibilidad:

- **Manejo de Estado:** [BLoC/Cubit](https://pub.dev/packages/flutter_bloc).
- **Inyección de Dependencias:** [GetIt](https://pub.dev/packages/get_it) con [Injectable](https://pub.dev/packages/injectable).
- **Navegación:** [GoRouter](https://pub.dev/packages/go_router) (Navegación 2.0).
- **Persistencia Local:** [SharedPreferences](https://pub.dev/packages/shared_preferences) (Simulación de API REST con Mocks).
- **Pruebas:** Unit tests para la lógica de negocio.

---

## ✨ Funcionalidades Implementadas

1.  ✅ **Visualización de Fondos:** Lista completa de fondos FPV y FIC con sus montos mínimos.
2.  ✅ **Suscripción:** Validación de saldo disponible y monto mínimo requerido.
3.  ✅ **Cancelación:** Reembolso automático al saldo y actualización inmediata de la UI.
4.  ✅ **Historial:** Registro detallado de suscripciones y cancelaciones.
5.  ✅ **Notificaciones:** Diálogo de selección de método (Email/SMS) al suscribirse.
6.  ✅ **Feedback Visual:** Manejo de estados de carga y diálogos de error informativos para saldo insuficiente.

---

## 🧪 Pruebas Unitarias

Para ejecutar las pruebas y verificar la integridad de la lógica:

```sh
flutter test
```

---

## 🌐 Internacionalización (l10n)

Si realizas cambios en las traducciones (archivos `.arb`):

```sh
flutter gen-l10n
```

---

**Nota:** Se asume un usuario único con un saldo inicial de **COP $500.000**.
