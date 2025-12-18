FROM ubuntu:22.04 as builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    libasio-dev \
    wget
WORKDIR /app

COPY . .

RUN wget https://github.com/CrowCpp/Crow/releases/download/v1.3.0/crow_all.h || true

RUN g++ main.cpp -lpthread -o currency_app

FROM ubuntu:22.04

RUN groupadd -r appuser && useradd -r -g appuser appuser

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libasio-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/currency_app .

RUN chown appuser:appuser currency_app
USER appuser

EXPOSE 8080

CMD ["./currency_app"]

