# -- Stage 1 -- #
# Compile the Go app.
FROM golang:1.12-alpine AS builder

# Set the working directory inside the container.
WORKDIR /app

# Copy go.mod and go.sum files first, then the rest of the app files.
COPY go.mod ./
RUN go mod tidy

# Copy the rest of the application files.
COPY . .

# Build the Go application (no vendor flag if you don't have a vendor folder).
RUN go build -o bin/hello

# -- Stage 2 -- #
# Create the final environment with the compiled binary.
FROM alpine

# Install any required dependencies (e.g., certificates).
RUN apk --no-cache add ca-certificates

# Set the working directory in the final image.
WORKDIR /root/

# Copy the binary from the builder stage to the final image.
COPY --from=builder /app/bin/hello /usr/local/bin/

# Set the default command to run the compiled Go binary.
CMD ["hello"]
