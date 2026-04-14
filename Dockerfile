# Usamos la imagen COMPLETA de Python 3.8 (garantiza cero errores de compilación en C)
FROM python:3.8-bullseye

WORKDIR /app

COPY requirements.txt /app/requirements.txt

# Instalamos SOLO las librerías de procesamiento de video para OpenCV
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

# Instalamos las librerías de Python
RUN python3 -m pip install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

COPY . /app

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--workers", "2", "--log-config", "./log_conf.yaml"]
