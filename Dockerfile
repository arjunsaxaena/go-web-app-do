FROM golang:1.22.5 AS base

WORKDIR /app

COPY go.mod .

RUN go mod download

COPY . .

RUN go build -o main .

# FINAL STAGE - DISTROLESS IMAGE (MAKES BUILD LIGHTWEIGHT)
FROM gcr.io/distroless/base

COPY --from=base /app/main .

# Static file i.e html files which are not bundled in go build
COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["./main"]

###############################################################
# Everywhere we have put '.' at end defines root directory
# Run - docker build -t build-name .
# Run - docker run -p 8080:8080 -it build-name
