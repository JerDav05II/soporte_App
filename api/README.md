# API de Soporte Técnico - Incidencias (FastAPI + MySQL)

Proyecto desarrollado para el examen usando **FastAPI**, **SQLAlchemy** y **MySQL / MariaDB** (compatible con XAMPP / phpMyAdmin).

---

## 📁 Estructura del Proyecto

```text
API/
├── .env                # Credenciales de conexión a MySQL (soporte_app)
├── .gitignore          # Archivos ignorados por Git
├── database.py         # Configuración del motor y sesión de SQLAlchemy
├── main.py             # Endpoints CRUD para incidencias
├── models.py           # Modelo SQLAlchemy mapeado a la tabla `incidencias`
├── requirements.txt    # Librerías necesarias
├── schemas.py          # Validación y Enums con Pydantic
├── soporte_app.sql     # Script SQL para importar en phpMyAdmin / MySQL
└── README.md           # Instrucciones de uso
```

---

## 🚀 Pasos para preparar y ejecutar el proyecto

### 1. Importar la Base de Datos en MySQL / phpMyAdmin

1. Abre tu panel de control de **XAMPP** y arranca el servicio de **MySQL** (y Apache si usas phpMyAdmin).
2. Entra a phpMyAdmin: `http://localhost/phpmyadmin/`.
3. Crea la base de datos `soporte_app` o ve a la pestaña **Importar** y selecciona el archivo `soporte_app.sql` que está en la raíz de este proyecto.

### 2. Verificar el archivo `.env`

Abre `.env` y confirma tus datos de conexión (por defecto en XAMPP el usuario es `root` y la contraseña está vacía):

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=soporte_app
```

### 3. Crear entorno virtual e instalar librerías

En la terminal (PowerShell o CMD dentro de la carpeta):

```powershell
# Crear y activar entorno virtual
python -m venv venv
.\venv\Scripts\Activate.ps1

# Instalar dependencias
pip install -r requirements.txt
```

### 4. Iniciar la API

```powershell
uvicorn main:app --reload
```

---

## 📌 Endpoints disponibles (CRUD)

Abre en tu navegador: 👉 **http://127.0.0.1:8000/docs**

| Método | Endpoint | Descripción |
| :--- | :--- | :--- |
| `GET` | `/` | Comprobación de estado del servicio |
| `GET` | `/incidencias/` | Listar todas (permite filtrar por `?estado=` o `?prioridad=`) |
| `GET` | `/incidencias/{id}` | Consultar una incidencia por su ID |
| `POST` | `/incidencias/` | Registrar una nueva incidencia |
| `PUT` | `/incidencias/{id}` | Modificar datos o cambiar estado (Pendiente / En proceso / Resuelta) |
| `DELETE` | `/incidencias/{id}` | Eliminar una incidencia |
