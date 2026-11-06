from fastapi import FastAPI, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from fastapi.middleware.cors import CORSMiddleware
import models
import schemas
from database import engine, get_db, SessionLocal

# Crea las tablas si no existen en la base de datos
models.Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="API de Soporte Técnico - Incidencias",
    description="API desarrollada en FastAPI y SQLAlchemy conectada a MySQL (soporte_app).",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Precargar datos del examen si la tabla está vacía
@app.on_event("startup")
def cargar_datos_iniciales():
    db = SessionLocal()
    try:
        if db.query(models.Incidencia).count() == 0:
            datos_ejemplo = [
                models.Incidencia(
                    nombre_usuario="Carlos Hernández",
                    correo="carlos@gmail.com",
                    numero_equipo=25,
                    descripcion="El equipo se reinicia constantemente.",
                    prioridad=models.PrioridadEnum.ALTA,
                    estado=models.EstadoEnum.PENDIENTE
                ),
                models.Incidencia(
                    nombre_usuario="María López",
                    correo="maria@gmail.com",
                    numero_equipo=12,
                    descripcion="El teclado presenta varias teclas que no funcionan.",
                    prioridad=models.PrioridadEnum.MEDIA,
                    estado=models.EstadoEnum.EN_PROCESO
                ),
                models.Incidencia(
                    nombre_usuario="José Martínez",
                    correo="jose@gmail.com",
                    numero_equipo=8,
                    descripcion="El equipo tarda demasiado tiempo en iniciar.",
                    prioridad=models.PrioridadEnum.BAJA,
                    estado=models.EstadoEnum.RESUELTA
                )
            ]
            db.add_all(datos_ejemplo)
            db.commit()
    except Exception as e:
        print(f"Aviso al precargar datos: {e}")
    finally:
        db.close()

@app.get("/")
def inicio():
    return {
        "mensaje": "API de Gestión de Incidencias activa",
        "docs": "/docs"
    }

# 1. Crear una nueva incidencia
@app.post(
    "/incidencias/",
    response_model=schemas.IncidenciaResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Registrar una nueva incidencia"
)
def crear_incidencia(incidencia: schemas.IncidenciaCreate, db: Session = Depends(get_db)):
    nueva_incidencia = models.Incidencia(
        nombre_usuario=incidencia.nombre_usuario,
        correo=incidencia.correo,
        numero_equipo=incidencia.numero_equipo,
        descripcion=incidencia.descripcion,
        prioridad=incidencia.prioridad,
        estado=incidencia.estado or models.EstadoEnum.PENDIENTE
    )
    db.add(nueva_incidencia)
    db.commit()
    db.refresh(nueva_incidencia)
    return nueva_incidencia

# 2. Listar incidencias (con filtro opcional por estado y prioridad)
@app.get(
    "/incidencias/",
    response_model=List[schemas.IncidenciaResponse],
    summary="Listar todas las incidencias"
)
def listar_incidencias(
    estado: Optional[schemas.EstadoEnum] = Query(None, description="Filtrar por estado"),
    prioridad: Optional[schemas.PrioridadEnum] = Query(None, description="Filtrar por prioridad"),
    db: Session = Depends(get_db)
):
    query = db.query(models.Incidencia)
    if estado:
        query = query.filter(models.Incidencia.estado == estado)
    if prioridad:
        query = query.filter(models.Incidencia.prioridad == prioridad)
    return query.all()

# 3. Obtener una incidencia por ID
@app.get(
    "/incidencias/{incidencia_id}",
    response_model=schemas.IncidenciaResponse,
    summary="Obtener una incidencia por ID"
)
def obtener_incidencia(incidencia_id: int, db: Session = Depends(get_db)):
    incidencia = db.query(models.Incidencia).filter(models.Incidencia.id == incidencia_id).first()
    if not incidencia:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Incidencia con ID {incidencia_id} no encontrada"
        )
    return incidencia

# 4. Actualizar una incidencia (ej. cambiar estado a 'En proceso' o 'Resuelta')
@app.put(
    "/incidencias/{incidencia_id}",
    response_model=schemas.IncidenciaResponse,
    summary="Actualizar una incidencia por ID"
)
def actualizar_incidencia(
    incidencia_id: int,
    datos: schemas.IncidenciaUpdate,
    db: Session = Depends(get_db)
):
    incidencia = db.query(models.Incidencia).filter(models.Incidencia.id == incidencia_id).first()
    if not incidencia:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Incidencia con ID {incidencia_id} no encontrada"
        )

    # Actualizar solo los campos que fueron enviados
    update_data = datos.model_dump(exclude_unset=True) if hasattr(datos, "model_dump") else datos.dict(exclude_unset=True)
    for clave, valor in update_data.items():
        setattr(incidencia, clave, valor)

    db.commit()
    db.refresh(incidencia)
    return incidencia

# 5. Eliminar una incidencia por ID
@app.delete(
    "/incidencias/{incidencia_id}",
    status_code=status.HTTP_200_OK,
    summary="Eliminar una incidencia por ID"
)
def eliminar_incidencia(incidencia_id: int, db: Session = Depends(get_db)):
    incidencia = db.query(models.Incidencia).filter(models.Incidencia.id == incidencia_id).first()
    if not incidencia:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Incidencia con ID {incidencia_id} no encontrada"
        )
    db.delete(incidencia)
    db.commit()
    return {"mensaje": f"Incidencia con ID {incidencia_id} eliminada exitosamente"}
