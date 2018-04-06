FROM golang:1.7-alpine as builder
LABEL maintainer="Deep Debroy ddebroy@docker.com"

RUN apk add --update bash git
RUN go get -u github.com/golang/dep/cmd/dep

ENV USER root
WORKDIR /go/
COPY . ./
WORKDIR /go/src/azip
RUN dep ensure
RUN go vet
RUN go install

FROM alpine:3.5 as deploy

RUN apk add --update bash ca-certificates jq curl && rm -Rf /tmp/* /var/lib/cache/apk/*

COPY --from=builder /go/bin/azip /usr/bin/
ADD init.sh /usr/bin/
RUN chmod +x /usr/bin/azip
RUN chmod +x /usr/bin/init.sh

CMD [ "/usr/bin/init.sh" ]
