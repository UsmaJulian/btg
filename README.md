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
   Este proyecto utiliza `injectable` y `build_runner`. **Debes ejecutar el siguiente comando** para generar los archivos de inyección de dependencias y configuraciones automáticas:

   ```sh
   dart run build_runner build --delete-conflicting-outputs
   ```

---

## 🏃 Ejecución del Proyecto

El proyecto está configurado con **Flavors** para separar entornos. Para ejecutarlo:

```sh
# Ejecución en modo desarrollo (Recomendado)
flutter run --flavor development --target lib/main_development.dart
```

---

## 🏗️ Arquitectura y Tecnologías

El proyecto sigue los principios de **Clean Architecture** y **SOLID** para garantizar escalabilidad y mantenibilidad:

### Estructura de Carpetas

```text
lib/
 ├── core/                 # Componentes transversales (DI, Errores, Theme, Utils)
 │    ├── result/          # Patrón Result (Success/Error) para manejo de flujo
 ├── features/             # Módulos funcionales
 │    ├── funds/           # Listado, detalle y suscripción de fondos
 │    ├── transactions/    # Historial de movimientos y persistencia local
 │    └── wallet/          # Gestión de saldo y balance del usuario
 └── l10n/                 # Soporte para internacionalización (i18n)
```

### Stack Técnico

- **Manejo de Estado:** [BLoC/Cubit](https://pub.dev/packages/flutter_bloc).
- **Inyección de Dependencias:** [GetIt](https://pub.dev/packages/get_it) + [Injectable](https://pub.dev/packages/injectable).
- **Navegación:** [GoRouter](https://pub.dev/packages/go_router) (Navegación declarativa).
- **Persistencia Local:** [SharedPreferences](https://pub.dev/packages/shared_preferences) (DataSource Pattern).
- **Inmutabilidad:** [Equatable](https://pub.dev/packages/equatable) para optimización de UI.

---

## 🧠 Decisiones Técnicas Destacadas

1. **Patrón Result:** Se implementó una clase `Result<T>` con variantes `Success` y `Error`. Esto evita el uso de excepciones para el control de flujo y garantiza que la UI siempre sepa cómo reaccionar ante un fallo de negocio.
2. **Desacoplamiento de Datos:** El uso de `DataSources` permite que la persistencia en `SharedPreferences` sea fácilmente reemplazable por una API REST o base de datos (Hive/Isar) sin tocar la lógica de los repositorios.
3. **DI Asíncrona:** Se configuró un módulo de `SharedPreferences` con `@preResolve` para asegurar que el almacenamiento local esté inicializado antes de que la aplicación arranque.

---

## ✨ Funcionalidades Implementadas

1. ✅ **Visualización de Fondos:** Lista completa de fondos FPV y FIC con montos mínimos.
2. ✅ **Suscripción:** Validación de saldo disponible vs monto mínimo requerido.
3. ✅ **Cancelación:** Reembolso automático al saldo y actualización reactiva de la billetera.
4. ✅ **Historial:** Registro detallado de transacciones ordenadas cronológicamente.
5. ✅ **Notificaciones:** Selección de método (Email/SMS) mediante diálogos interactivos.
6. ✅ **Feedback Visual:** Manejo de estados de carga, errores de saldo insuficiente y éxito.

---

## 🧪 Estrategia de Testing

Se ha implementado una suite de pruebas robusta para asegurar la integridad del sistema:

- **Unit Tests:** Pruebas de lógica en `Cubits` y `Repositories` usando `bloc_test` y `mocktail`.
- **Widget Tests:** Validación de componentes visuales y estados de interacción (e.g., `FundCard`).
- **Integration Tests:** Pruebas de flujo completo que validan el proceso desde la carga de datos hasta la suscripción exitosa.

Para ejecutar todas las pruebas:

```sh
flutter test
```

### Cobertura de Código

Para generar un reporte de cobertura detallado:

```sh
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
# Abrir coverage/html/index.html en el navegador
```

---

## 🌐 Internacionalización (l10n)

La aplicación está preparada para multi-idioma. Si realizas cambios en los archivos `.arb`:

```sh
flutter gen-l10n
```

```

```

---

## 🌐 Internacionalización (l10n)

La aplicación está preparada para multi-idioma. Si realizas cambios en los archivos `.arb`:

```sh
flutter gen-l10n
