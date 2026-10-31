FROM golang:1.26-alpine AS build
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /translator ./cmd/translator

FROM alpine:3.21
RUN adduser -D app
USER app
COPY --from=build /translator /translator
EXPOSE 8096
ENTRYPOINT ["/translator"]
