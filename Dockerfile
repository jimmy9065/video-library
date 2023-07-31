# Build stage
FROM golang:1.20-bookworm AS build-env

# Set up working directory
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source from the current directory to the working directory inside the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -o main ./cmd/video-library

# Final stage
FROM golang:1.20-alpine

WORKDIR /app

# Copy the binary from build stage
COPY --from=build-env /app/main .

# Expose port 8080 for the application
EXPOSE 8080

# Command to run the executable
CMD ["./main", "/data"]

