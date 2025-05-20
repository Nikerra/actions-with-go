# Stage 1: Сборка бинарника
FROM golang:1.24.2 AS builder

# Установим git (нужен для go get)
RUN apt-get update && apt-get install -y git

# Создаем рабочую директорию
WORKDIR /pro

# Копируем Go-код
COPY ./usePost05.go .

# Подтягиваем зависимости и собираем
RUN go mod init pro && \
    go mod tidy && \
    go build -o server usePost05.go

# Stage 2: Минимальный образ на Alpine
FROM alpine:latest

# Создаем директорию и копируем бинарник
WORKDIR /pro
COPY --from=builder /pro/server .

# Устанавливаем необходимые зависимости (если нужно)
# Например, если в программе используются сетевые функции
RUN apk add --no-cache ca-certificates

# Запускаем бинарник
CMD ["./server"]
