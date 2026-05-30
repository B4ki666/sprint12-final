FROM golang:1.26-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /parcel-tracker

FROM alpine:3.23.4
WORKDIR /app
COPY --from=builder /parcel-tracker .
COPY --from=builder /app/tracker.db .
CMD ["./parcel-tracker"]