FROM ruby:3.1-alpine

RUN apk add --no-cache build-base sqlite sqlite-dev sqlite-libs tzdata

ENV BUNDLE_PATH /bundle

WORKDIR /app

ADD Gemfile Gemfile.lock ./
RUN bundle install

ADD . .

ENTRYPOINT ["docker/entrypoint.sh"]
CMD ["bundle", "exec", "rspec", "-f", "d"]
