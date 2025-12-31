FROM python:3.11-slim

WORKDIR /app

# 시스템 의존성 설치
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Python 의존성 설치
COPY app/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# AWS SDK 설치 (S3 접근용)
RUN pip install --no-cache-dir boto3>=1.28.0

# 애플리케이션 코드 복사
COPY app/ .

# 모델 디렉토리 생성
RUN mkdir -p /app/models

# 포트 노출
EXPOSE 8000

# 환경 변수 설정
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# 애플리케이션 실행
CMD ["uvicorn", "api_server:app", "--host", "0.0.0.0", "--port", "8000"]

