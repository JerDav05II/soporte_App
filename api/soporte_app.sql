-- Base de datos: `soporte_app`
CREATE DATABASE IF NOT EXISTS `soporte_app` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `soporte_app`;

-- Estructura de tabla para la tabla `incidencias`
CREATE TABLE IF NOT EXISTS `incidencias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_usuario` varchar(100) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `numero_equipo` int(11) NOT NULL,
  `descripcion` varchar(500) NOT NULL,
  `prioridad` enum('Baja','Media','Alta') NOT NULL,
  `estado` enum('Pendiente','En proceso','Resuelta') NOT NULL DEFAULT 'Pendiente',
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcado de datos para la tabla `incidencias`
INSERT INTO `incidencias` (`id`, `nombre_usuario`, `correo`, `numero_equipo`, `descripcion`, `prioridad`, `estado`, `fecha_registro`) VALUES
(1, 'Carlos Hernández', 'carlos@gmail.com', 25, 'El equipo se reinicia constantemente.', 'Alta', 'Pendiente', '2026-09-23 21:20:15'),
(2, 'María López', 'maria@gmail.com', 12, 'El teclado presenta varias teclas que no funcionan.', 'Media', 'En proceso', '2026-09-23 21:20:15'),
(3, 'José Martínez', 'jose@gmail.com', 8, 'El equipo tarda demasiado tiempo en iniciar.', 'Baja', 'Resuelta', '2026-09-23 21:20:15')
ON DUPLICATE KEY UPDATE id=id;
