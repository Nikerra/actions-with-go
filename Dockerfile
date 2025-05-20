# Stage 1: Сборка бинарника
FROM golang:1.24.2 AS builder

RUN apt-get update && apt-get install -y git

WORKDIR /pro

COPY ./usePost05.go .

RUN go mod init pro && \
    go mod tidy && \
    CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o server usePost05.go

# Stage 2: Минимальный образ на Alpine
FROM alpine:latest

WORKDIR /pro

COPY --from=builder /pro/server .

RUN apk add --no-cache ca-certificates

CMD ["./server"]
