from sqlalchemy import Column, Integer, String, DateTime, Enum, func
from database import Base
import enum

# Enums de Python para mantener consistencia con los ENUM de MySQL
class PrioridadEnum(str, enum.Enum):
    BAJA = "Baja"
    MEDIA = "Media"
    ALTA = "Alta"

class EstadoEnum(str, enum.Enum):
    PENDIENTE = "Pendiente"
    EN_PROCESO = "En proceso"
    RESUELTA = "Resuelta"

class Incidencia(Base):
    __tablename__ = "incidencias"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    nombre_usuario = Column(String(100), nullable=False)
    correo = Column(String(150), nullable=False)
    numero_equipo = Column(Integer, nullable=False)
    descripcion = Column(String(500), nullable=False)
    prioridad = Column(Enum("Baja", "Media", "Alta", name="prioridad_enum"), nullable=False)
    estado = Column(Enum("Pendiente", "En proceso", "Resuelta", name="estado_enum"), nullable=False, default="Pendiente")
    fecha_registro = Column(DateTime, server_default=func.now())
