# syntax=docker/dockerfile:1

## BUILD

FROM golang:1.18.1-buster AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./

RUN go mod download

ADD . ./

RUN make build/blog

## Deploy

FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /app/bin/linux_amd64/blog /blog

EXPOSE 4000

USER nonroot:nonroot

ENTRYPOINT ["/blog"]