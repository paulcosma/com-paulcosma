#
# Builder Image
#
# Ensure everyone is running the same version of golang.
# https://hub.docker.com/_/golang?tab=tags
# https://github.com/docker-library/golang
ARG GOLAN_VERSION=1.20.7-bullseye
ARG NGINX_VERSION=1.25.1-alpine
FROM golang:${GOLAN_VERSION} as builder

# Install Hugo from source
# https://github.com/gohugoio/hugo/tags
ARG HUGO_VERSION=v0.111.3
RUN apt-get update && apt-get install git
RUN git version
WORKDIR /src
RUN git clone https://github.com/gohugoio/hugo.git --branch ${HUGO_VERSION} --single-branch
WORKDIR /src/hugo
RUN go install --tags extended

# Generate website to the public directory
#RUN git clone --recurse-submodule --single-branch --branch master https://github.com/paulcosma/com-paulcosma.git
COPY ./ /src/hugo/com-paulcosma
WORKDIR /src/hugo/com-paulcosma
RUN git submodule add https://github.com/Track3/hermit.git themes/hermit
RUN git submodule update --recursive
RUN hugo

#
# Add static website to webserver
#
# https://hub.docker.com/_/nginx/?tab=tags
# https://github.com/nginxinc/docker-nginx
FROM nginx:${NGINX_VERSION}

# Copy build files from builder.
COPY --from=builder /src/hugo/com-paulcosma/public /usr/share/nginx/html/

# Expose ports
EXPOSE 80
