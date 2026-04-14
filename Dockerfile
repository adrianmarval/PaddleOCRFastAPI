FROM python:3.8-slim-bullseye

WORKDIR /app

COPY requirements.txt /app/requirements.txt

# Forzar reconstruccion limpia v2
# Instalamos solo las dependencias visuales de Linux desde los repositorios globales
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libgl1 \
        libgomp1 \
        libglib2.0-0 \
        libsm6 \
        libxrender1 \
        libxext6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instalamos Python usando el PyPI oficial para obtener los binarios directos (Wheels)
RUN python3 -m pip install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

COPY . /app

# Comando de arranque original
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--workers", "2", "--log-config", "./log_conf.yaml"]
