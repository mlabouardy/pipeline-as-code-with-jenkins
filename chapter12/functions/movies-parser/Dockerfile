FROM golang:1.13.4
WORKDIR /go/src/github.com/mlabouardy/movies-parser
COPY main.go .
RUN go get -v
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main main.go