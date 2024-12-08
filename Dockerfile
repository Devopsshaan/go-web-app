# Base stage for building the Go application
FROM golang:1.22.5 AS base

# Set the working directory inside the container
WORKDIR /app

# Copy the dependency file and download dependencies
COPY go.mod .
RUN go mod download

# Copy the application source code
COPY . .

# Build the application binary
RUN go build -o main .

# Final stage using a Distroless image
FROM gcr.io/distroless/base

# Copy the compiled binary from the build stage
COPY --from=base /app/main .

# Copy static files if they exist
# Ensure /app/static exists in the source directory; remove this line if not applicable
COPY --from=base /app/static ./static

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["./main"]
