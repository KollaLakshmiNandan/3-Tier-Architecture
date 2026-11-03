FROM python:3.12-slim

RUN useradd --create-home appuser

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade "pip>=26.2.0" "setuptools>=83.0.0" "msgpack>=1.2.1" && \
    pip install --no-cache-dir -r requirements.txt

COPY app.py .

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
