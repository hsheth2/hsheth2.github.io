FROM ruby:3.4.5 AS builder

ENV JEKYLL_ENV=production
ENV APP_DIR=/app
WORKDIR $APP_DIR

COPY Gemfile $APP_DIR
COPY Gemfile.lock $APP_DIR
RUN bundle install

COPY . .
RUN bundle exec jekyll build

EXPOSE 4000
CMD [ "bundle", "exec", "jekyll", "serve", "--host=0.0.0.0" ]
#FROM nginx
#COPY --from=builder /app/_site /usr/share/nginx/html
