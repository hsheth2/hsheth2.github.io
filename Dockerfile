FROM jekyll/jekyll AS builder

COPY . /srv/jekyll
RUN jekyll build

FROM nginx
COPY --from=builder /srv/jekyll/_site /usr/share/nginx/html
