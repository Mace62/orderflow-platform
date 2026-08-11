# Stage 1: Builder
FROM golang:1.26-alpine@sha256:0178a641fbb4858c5f1b48e34bdaabe0350a330a1b1149aabd498d0699ff5fb2 AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .

# CGO disabled to build a static binary
RUN CGO_ENABLED=0 GOOS=linux go build -o dashboard-api main.go

# Stage 2: Runner (non-root)
FROM gcr.io/distroless/static-debian13:nonroot@sha256:f7f8f729987ad0fdf6b05eeeae94b26e6a0f613bdf46feea7fc40f7bd72953e6

WORKDIR /app
COPY --from=builder /app/dashboard-api .
EXPOSE 8086
CMD ["./dashboard-api"]
