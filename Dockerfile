FROM python:3.10.18-alpine
WORKDIR /app
COPY . .
CMD ["python3","hello.py"]