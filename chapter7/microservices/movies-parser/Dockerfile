FROM golang:1.13.4
WORKDIR /go/src/github.com/mlabouardy/movies-loader
COPY main.go .
RUN go get -v
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app main.go

FROM alpine:latest  
LABEL Maintainer mlabouardy
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /go/src/github.com/mlabouardy/movies-loader/app .
CMD ["./app"] 