from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime
from enum import Enum

# Opciones válidas para prioridad y estado (coinciden exactamente con MySQL)
class PrioridadEnum(str, Enum):
    BAJA = "Baja"
    MEDIA = "Media"
    ALTA = "Alta"

class EstadoEnum(str, Enum):
    PENDIENTE = "Pendiente"
    EN_PROCESO = "En proceso"
    RESUELTA = "Resuelta"

# Esquema base con los datos comunes
class IncidenciaBase(BaseModel):
    nombre_usuario: str
    correo: str
    numero_equipo: int
    descripcion: str
    prioridad: PrioridadEnum
    estado: Optional[EstadoEnum] = EstadoEnum.PENDIENTE

# Esquema para crear una incidencia (datos que envía el cliente)
class IncidenciaCreate(IncidenciaBase):
    pass

# Esquema para actualizar una incidencia (todos los campos opcionales)
class IncidenciaUpdate(BaseModel):
    nombre_usuario: Optional[str] = None
    correo: Optional[str] = None
    numero_equipo: Optional[int] = None
    descripcion: Optional[str] = None
    prioridad: Optional[PrioridadEnum] = None
    estado: Optional[EstadoEnum] = None

# Esquema para la respuesta al cliente (incluye id y fecha_registro generados)
class IncidenciaResponse(IncidenciaBase):
    id: int
    fecha_registro: Optional[datetime] = None

    class Config:
        from_attributes = True
