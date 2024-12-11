# Use official golang base image
FROM golang:1.12-alpine AS builder

# Set working directory
WORKDIR /app

# Copy go.mod and go.sum files to the container
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the entire project to the container
COPY . .

# Build the Go binary
RUN go build -mod=vendor -o bin/hello

# Use a smaller image for the final build
FROM alpine:latest

# Install necessary dependencies
RUN apk --no-cache add ca-certificates

# Set working directory for the final image
WORKDIR /root/

# Copy the built binary from the builder stage
COPY --from=builder /app/bin/hello /usr/local/bin/

# Set entrypoint to the Go binary
ENTRYPOINT ["/usr/local/bin/hello"]
