# Builder Image
# Ensure everyone is running the same version of golang.
# https://hub.docker.com/_/golang?tab=tags
# https://github.com/docker-library/golang
FROM golang:1.12.9-buster as builder

# Install Hugo from source
RUN apt-get update && apt-get install git
WORKDIR /src
RUN git clone https://github.com/gohugoio/hugo.git
WORKDIR /src/hugo
RUN go install --tags extended

# Generate website to the public directory
RUN git clone --recurse-submodule --single-branch --branch v2.0 https://github.com/paulcosma/com.paulcosma.git
#COPY ./ /src/hugo/com.paulcosma
WORKDIR /src/hugo/com.paulcosma
RUN hugo

# Add static website to webserver
# https://hub.docker.com/_/nginx/?tab=tags
# https://github.com/nginxinc/docker-nginx
FROM nginx:alpine

# Copy build files from builder.
COPY --from=builder /src/hugo/com.paulcosma/public /usr/share/nginx/html/

# Expose ports
EXPOSE 80