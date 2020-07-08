#
# Builder Image
#
# Ensure everyone is running the same version of golang.
# https://hub.docker.com/_/golang?tab=tags
# https://github.com/docker-library/golang
ARG  GOLAN_VERSION=1.13.12-buster
FROM golang:${GOLAN_VERSION} as builder

# Install Hugo from source
# https://github.com/gohugoio/hugo/tags
ARG HUGO_VERSION=v0.73.0
RUN apt-get update && apt-get install git
RUN git version
WORKDIR /src
RUN git clone https://github.com/gohugoio/hugo.git --branch ${HUGO_VERSION} --single-branch
WORKDIR /src/hugo
RUN go install --tags extended
RUN hugo version

# Generate website to the public directory
#RUN git clone --recurse-submodule --single-branch --branch master https://github.com/paulcosma/com-paulcosma.git
COPY ./ /src/hugo/com-paulcosma
WORKDIR /src/hugo/com-paulcosma
RUN git submodule update --init --recursive
RUN ls -alh
RUN ls -alh themes/hermit
RUN hugo

#
# Add static website to webserver
#
# https://hub.docker.com/_/nginx/?tab=tags
# https://github.com/nginxinc/docker-nginx
ARG  NGINX_VERSION=1.19.0-alpine
FROM nginx:${NGINX_VERSION}

# Copy build files from builder.
COPY --from=builder /src/hugo/com-paulcosma/public /usr/share/nginx/html/

# Expose ports
EXPOSE 80
