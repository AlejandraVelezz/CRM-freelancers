-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-06-2026 a las 20:46:50
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `freelancer_os`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `workspace_id` int(11) NOT NULL,
  `persona_id` int(11) NOT NULL,
  `codigo_cliente` varchar(30) DEFAULT NULL,
  `fecha_registro` date DEFAULT curdate(),
  `categoria` enum('PERSONA','EMPRESA','GOBIERNO','ONG') DEFAULT 'PERSONA',
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `correos_historial`
--

CREATE TABLE `correos_historial` (
  `id` int(11) NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `proyecto` varchar(150) DEFAULT NULL,
  `contenido` text NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresas`
--

CREATE TABLE `empresas` (
  `id` int(11) NOT NULL,
  `workspace_id` int(11) NOT NULL,
  `uuid` char(36) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `nit` varchar(50) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `sitio_web` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `pais` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `estado` enum('ACTIVA','INACTIVA') DEFAULT 'ACTIVA',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estados_proyecto`
--

CREATE TABLE `estados_proyecto` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `color` varchar(20) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estados_proyecto`
--

INSERT INTO `estados_proyecto` (`id`, `nombre`, `color`, `descripcion`) VALUES
(1, 'Pendiente', '#6B7280', 'Proyecto creado'),
(2, 'En Progreso', '#3B82F6', 'Proyecto en desarrollo'),
(3, 'En Revisión', '#F59E0B', 'Esperando aprobación del cliente'),
(4, 'Finalizado', '#10B981', 'Proyecto terminado'),
(5, 'Cancelado', '#EF4444', 'Proyecto cancelado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fases`
--

CREATE TABLE `fases` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `orden` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `fases`
--

INSERT INTO `fases` (`id`, `nombre`, `descripcion`, `orden`) VALUES
(1, 'Análisis', 'Levantamiento de información', 1),
(2, 'Diseño', 'Diseño UI/UX', 2),
(3, 'Desarrollo', 'Programación', 3),
(4, 'Pruebas', 'QA y validaciones', 4),
(5, 'Entrega', 'Entrega al cliente', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id` int(11) NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `asunto` varchar(200) NOT NULL,
  `mensaje` text NOT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`id`, `nombre`, `descripcion`, `created_at`) VALUES
(1, 'usuarios.ver', '', '2026-06-25 14:53:53'),
(2, 'usuarios.crear', '', '2026-06-25 14:53:53'),
(3, 'usuarios.editar', '', '2026-06-25 14:53:53'),
(4, 'usuarios.eliminar', '', '2026-06-25 14:53:53'),
(5, 'clientes.ver', '', '2026-06-25 14:53:53'),
(6, 'clientes.crear', '', '2026-06-25 14:53:53'),
(7, 'proyectos.ver', '', '2026-06-25 14:53:53'),
(8, 'proyectos.crear', '', '2026-06-25 14:53:53');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas`
--

CREATE TABLE `personas` (
  `id` int(11) NOT NULL,
  `workspace_id` int(11) NOT NULL,
  `empresa_id` int(11) DEFAULT NULL,
  `uuid` char(36) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `documento` varchar(30) DEFAULT NULL,
  `tipo_documento` enum('CC','CE','NIT','PASAPORTE') DEFAULT 'CC',
  `email` varchar(150) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `celular` varchar(50) DEFAULT NULL,
  `cargo` varchar(100) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `pais` varchar(100) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prioridades`
--

CREATE TABLE `prioridades` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `color` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prioridades`
--

INSERT INTO `prioridades` (`id`, `nombre`, `color`) VALUES
(1, 'Baja', '#22C55E'),
(2, 'Media', '#FACC15'),
(3, 'Alta', '#F97316'),
(4, 'Crítica', '#DC2626');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyectos`
--

CREATE TABLE `proyectos` (
  `id` int(11) NOT NULL,
  `workspace_id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `uuid` char(36) DEFAULT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `nombre` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `presupuesto` decimal(12,2) DEFAULT NULL,
  `estado_id` int(11) NOT NULL,
  `prioridad_id` int(11) NOT NULL,
  `porcentaje_avance` decimal(5,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto_fases`
--

CREATE TABLE `proyecto_fases` (
  `id` int(11) NOT NULL,
  `proyecto_id` int(11) NOT NULL,
  `fase_id` int(11) NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `estado` enum('PENDIENTE','EN_PROCESO','FINALIZADA') DEFAULT 'PENDIENTE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto_usuarios`
--

CREATE TABLE `proyecto_usuarios` (
  `id` int(11) NOT NULL,
  `proyecto_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `rol_proyecto` enum('LIDER','DESARROLLADOR','DISEÑADOR','TESTER','CLIENTE') DEFAULT 'DESARROLLADOR',
  `fecha_asignacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `nombre`, `descripcion`, `created_at`) VALUES
(1, 'Administrador', 'Administrador del sistema', '2026-06-25 14:53:41'),
(2, 'Freelancer', 'Usuario regular del sistema', '2026-06-25 14:53:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_permisos`
--

CREATE TABLE `rol_permisos` (
  `rol_id` int(11) NOT NULL,
  `permiso_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tareas`
--

CREATE TABLE `tareas` (
  `id` int(11) NOT NULL,
  `proyecto_fase_id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `uuid` char(36) NOT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `titulo` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `estado` enum('PENDIENTE','EN_PROCESO','EN_REVISION','FINALIZADA','CANCELADA') DEFAULT 'PENDIENTE',
  `prioridad` enum('BAJA','MEDIA','ALTA','CRITICA') DEFAULT 'MEDIA',
  `porcentaje` decimal(5,2) DEFAULT 0.00,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_limite` date DEFAULT NULL,
  `fecha_finalizacion` date DEFAULT NULL,
  `horas_estimadas` decimal(6,2) DEFAULT NULL,
  `horas_reales` decimal(6,2) DEFAULT NULL,
  `orden` int(11) DEFAULT 1,
  `color` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `workspace_id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `foto` varchar(255) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO','BLOQUEADO') NOT NULL DEFAULT 'ACTIVO',
  `ultimo_login` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `workspace_id`, `nombre`, `apellido`, `email`, `password`, `foto`, `estado`, `ultimo_login`, `created_at`, `updated_at`) VALUES
(1, 3, 'Juana', 'Salas', 'salasAna@gmail.com', '$2b$12$x5uvE2BY80lZPvq3lszz.OXfQji31uI/UizC0n82IQ18vFtc0xYmu', 'default.png', 'ACTIVO', '2026-06-25 21:00:01', '2026-06-26 02:00:01', '2026-06-26 02:00:01'),
(2, 4, 'Luis', 'Franco', 'luis89@gmail.com', '$2b$12$AX7o/KLXAsz1jv8sRFe7WePRBDekzxAUKorbUurW6QT6rHuLVlS4e', 'default.png', 'ACTIVO', '2026-06-25 21:04:26', '2026-06-26 02:04:26', '2026-06-26 02:04:26'),
(3, 5, 'Alejandra', 'Velez', 'alejandra.prueba@gmail.com', '$2b$12$2x1ODU./VkmF.tSwUrNux.9/nxPph6F2LPkg6zA1cmcNXDECJ.fDq', 'default.png', 'ACTIVO', '2026-06-26 10:11:05', '2026-06-26 15:11:05', '2026-06-26 15:11:05'),
(4, 6, 'Niguel', 'Suarez', 'niguel89@gmail.com', '$2b$12$3YArcmDcg0EDhfLGA/QkgeqdS7AZGX93nE8AeA8Cn97DrRuLnr5QS', 'default.png', 'ACTIVO', '2026-06-26 10:13:10', '2026-06-26 15:13:10', '2026-06-26 15:13:10'),
(5, 7, 'Alexa', 'Velez', 'alexandra.prueba@gmail.com', '$2b$12$arKXQYr6YUU5.lGgR.GVM.7tITAM3R1v.dPJEu.a0O60XI0YHGxNC', 'default.png', 'ACTIVO', '2026-06-26 10:15:17', '2026-06-26 15:15:17', '2026-06-26 15:15:17'),
(6, 8, 'Alejandro', 'Vélez', 'alejandro.zapata@gmail.com', '$2b$12$ORDZ9Q7Ta6FAfIfuODPJSeWqCxQHm/esToK0zo7GPCfTDjq/8TtGC', 'default.png', 'ACTIVO', '2026-06-26 18:21:10', '2026-06-26 23:21:10', '2026-06-26 23:21:10'),
(7, 9, 'Samuel', 'Delgado', 'delgadosamu@gmail.com', '$2b$12$pZRSCgb9XcuMrrpHF2sYpOhPN4zU36WLR00jLlqQ6ZQKnDQVRyvsu', 'default.png', 'ACTIVO', '2026-06-26 18:44:29', '2026-06-26 23:44:29', '2026-06-26 23:44:29'),
(8, 10, 'juan', 'cardona', 'jcardona@gmail.com', '$2b$12$DIyh00bLh0qfaLcN5NI1AuU5qRSSJ5fekhXdk8Q8JDJZTpKdwUZFa', 'default.png', 'ACTIVO', '2026-06-26 20:11:04', '2026-06-27 01:11:04', '2026-06-27 01:11:04'),
(10, 4, 'Pedro', 'Pedro', 'yo@yo.com', '123', '', 'ACTIVO', '2026-06-27 03:17:08', '2026-06-27 01:18:11', '2026-06-27 01:18:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_roles`
--

CREATE TABLE `usuario_roles` (
  `usuario_id` int(11) NOT NULL,
  `rol_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario_roles`
--

INSERT INTO `usuario_roles` (`usuario_id`, `rol_id`) VALUES
(2, 1),
(3, 1),
(5, 1),
(6, 2),
(7, 2),
(8, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `workspace`
--

CREATE TABLE `workspace` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `slug` varchar(150) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `workspace`
--

INSERT INTO `workspace` (`id`, `nombre`, `slug`, `descripcion`, `logo`, `estado`, `created_at`, `updated_at`) VALUES
(1, 'CRM Freelancer', 'crm-freelancer', 'Workspace principal', 'logo.png', 'ACTIVO', '2026-06-26 01:02:18', '2026-06-26 01:02:18'),
(3, 'Web integral', 'web-integral-e2e70ef0', 'espacio para desarrollo de cada uno de los modulos', 'logo.png', 'ACTIVO', '2026-06-26 02:00:01', '2026-06-26 02:00:01'),
(4, 'Web Empresarial Inicial', 'web-empresarial-inicial-f0c7ec7e', 'Esacio de desarrollo de wweb para empresa consolidada', 'logo.png', 'ACTIVO', '2026-06-26 02:04:26', '2026-06-26 02:04:26'),
(5, 'CRM Alejandra', 'crm-alejandra-49e37c0d', 'Workspace de prueba', 'logo.png', 'ACTIVO', '2026-06-26 15:11:05', '2026-06-26 15:11:05'),
(6, 'Login', 'login-9771b879', 'Inicio desarrollo construccion login', 'logo.png', 'ACTIVO', '2026-06-26 15:13:10', '2026-06-26 15:13:10'),
(7, 'CRM Alejandra', 'crm-alejandra-5fabf234', 'Workspace de prueba', 'logo.png', 'ACTIVO', '2026-06-26 15:15:16', '2026-06-26 15:15:16'),
(8, 'CRM New', 'crm-new-f9c426f4', 'Workspace creado automáticamente', 'logo.png', 'ACTIVO', '2026-06-26 23:21:09', '2026-06-26 23:21:09'),
(9, 'DsLink', 'dslink-21ed7adb', 'Workspace creado automáticamente', 'logo.png', 'ACTIVO', '2026-06-26 23:44:29', '2026-06-26 23:44:29'),
(10, 'DS', 'ds-007aeaa5', 'Workspace creado automáticamente', 'logo.png', 'ACTIVO', '2026-06-27 01:11:04', '2026-06-27 01:11:04');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo_cliente` (`codigo_cliente`),
  ADD KEY `fk_cliente_workspace` (`workspace_id`),
  ADD KEY `fk_cliente_persona` (`persona_id`),
  ADD KEY `fk_cliente_created` (`created_by`),
  ADD KEY `fk_cliente_updated` (`updated_by`);

--
-- Indices de la tabla `correos_historial`
--
ALTER TABLE `correos_historial`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cliente_id` (`cliente_id`),
  ADD KEY `ix_correos_historial_usuario_id` (`usuario_id`),
  ADD KEY `ix_correos_historial_id` (`id`);

--
-- Indices de la tabla `empresas`
--
ALTER TABLE `empresas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `fk_empresa_workspace` (`workspace_id`),
  ADD KEY `fk_empresa_created` (`created_by`),
  ADD KEY `fk_empresa_updated` (`updated_by`);

--
-- Indices de la tabla `estados_proyecto`
--
ALTER TABLE `estados_proyecto`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `fases`
--
ALTER TABLE `fases`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cliente_id` (`cliente_id`),
  ADD KEY `ix_notificaciones_id` (`id`),
  ADD KEY `ix_notificaciones_usuario_id` (`usuario_id`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `personas`
--
ALTER TABLE `personas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD KEY `fk_persona_workspace` (`workspace_id`),
  ADD KEY `fk_persona_empresa` (`empresa_id`),
  ADD KEY `fk_persona_created` (`created_by`),
  ADD KEY `fk_persona_updated` (`updated_by`);

--
-- Indices de la tabla `prioridades`
--
ALTER TABLE `prioridades`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `proyectos`
--
ALTER TABLE `proyectos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `fk_proyecto_workspace` (`workspace_id`),
  ADD KEY `fk_proyecto_cliente` (`cliente_id`),
  ADD KEY `fk_proyecto_estado` (`estado_id`),
  ADD KEY `fk_proyecto_prioridad` (`prioridad_id`),
  ADD KEY `fk_proyecto_created` (`created_by`),
  ADD KEY `fk_proyecto_updated` (`updated_by`);

--
-- Indices de la tabla `proyecto_fases`
--
ALTER TABLE `proyecto_fases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proyecto_id` (`proyecto_id`),
  ADD KEY `fase_id` (`fase_id`);

--
-- Indices de la tabla `proyecto_usuarios`
--
ALTER TABLE `proyecto_usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `proyecto_id` (`proyecto_id`,`usuario_id`),
  ADD KEY `fk_pu_usuario` (`usuario_id`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rol_permisos`
--
ALTER TABLE `rol_permisos`
  ADD PRIMARY KEY (`rol_id`);

--
-- Indices de la tabla `tareas`
--
ALTER TABLE `tareas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid` (`uuid`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `fk_tarea_fase` (`proyecto_fase_id`),
  ADD KEY `fk_tarea_usuario` (`usuario_id`),
  ADD KEY `fk_tarea_created` (`created_by`),
  ADD KEY `fk_tarea_updated` (`updated_by`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_usuario_workspace` (`workspace_id`);

--
-- Indices de la tabla `usuario_roles`
--
ALTER TABLE `usuario_roles`
  ADD PRIMARY KEY (`usuario_id`),
  ADD KEY `fk_roles_id` (`rol_id`);

--
-- Indices de la tabla `workspace`
--
ALTER TABLE `workspace`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `correos_historial`
--
ALTER TABLE `correos_historial`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empresas`
--
ALTER TABLE `empresas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estados_proyecto`
--
ALTER TABLE `estados_proyecto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `fases`
--
ALTER TABLE `fases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `personas`
--
ALTER TABLE `personas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `prioridades`
--
ALTER TABLE `prioridades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `proyectos`
--
ALTER TABLE `proyectos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proyecto_fases`
--
ALTER TABLE `proyecto_fases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proyecto_usuarios`
--
ALTER TABLE `proyecto_usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `rol_permisos`
--
ALTER TABLE `rol_permisos`
  MODIFY `rol_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tareas`
--
ALTER TABLE `tareas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `workspace`
--
ALTER TABLE `workspace`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `fk_cliente_created` FOREIGN KEY (`created_by`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_cliente_persona` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cliente_updated` FOREIGN KEY (`updated_by`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_cliente_workspace` FOREIGN KEY (`workspace_id`) REFERENCES `workspace` (`id`);

--
-- Filtros para la tabla `correos_historial`
--
ALTER TABLE `correos_historial`
  ADD CONSTRAINT `correos_historial_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `correos_historial_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `empresas`
--
ALTER TABLE `empresas`
  ADD CONSTRAINT `fk_empresa_created` FOREIGN KEY (`created_by`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_empresa_updated` FOREIGN KEY (`updated_by`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_empresa_workspace` FOREIGN KEY (`workspace_id`) REFERENCES `workspace` (`id`);

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notificaciones_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `personas`
--
ALTER TABLE `personas`
  ADD CONSTRAINT `fk_persona_created` FOREIGN KEY (`created_by`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_persona_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_persona_updated` FOREIGN KEY (`updated_by`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_persona_workspace` FOREIGN KEY (`workspace_id`) REFERENCES `workspace` (`id`);

--
-- Filtros para la tabla `proyectos`
--
ALTER TABLE `proyectos`
  ADD CONSTRAINT `fk_proyecto_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`),
  ADD CONSTRAINT `fk_proyecto_created` FOREIGN KEY (`created_by`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_proyecto_estado` FOREIGN KEY (`estado_id`) REFERENCES `estados_proyecto` (`id`),
  ADD CONSTRAINT `fk_proyecto_prioridad` FOREIGN KEY (`prioridad_id`) REFERENCES `prioridades` (`id`),
  ADD CONSTRAINT `fk_proyecto_updated` FOREIGN KEY (`updated_by`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_proyecto_workspace` FOREIGN KEY (`workspace_id`) REFERENCES `workspace` (`id`);

--
-- Filtros para la tabla `proyecto_fases`
--
ALTER TABLE `proyecto_fases`
  ADD CONSTRAINT `proyecto_fases_ibfk_1` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `proyecto_fases_ibfk_2` FOREIGN KEY (`fase_id`) REFERENCES `fases` (`id`);

--
-- Filtros para la tabla `proyecto_usuarios`
--
ALTER TABLE `proyecto_usuarios`
  ADD CONSTRAINT `fk_pu_proyecto` FOREIGN KEY (`proyecto_id`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pu_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `tareas`
--
ALTER TABLE `tareas`
  ADD CONSTRAINT `fk_tarea_created` FOREIGN KEY (`created_by`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_tarea_fase` FOREIGN KEY (`proyecto_fase_id`) REFERENCES `proyecto_fases` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tarea_updated` FOREIGN KEY (`updated_by`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_tarea_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuario_workspace` FOREIGN KEY (`workspace_id`) REFERENCES `workspace` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuario_roles`
--
ALTER TABLE `usuario_roles`
  ADD CONSTRAINT `fk_roles_id` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `fk_usuario_users` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
