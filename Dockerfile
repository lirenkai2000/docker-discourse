FROM rails

WORKDIR /usr/src/app

ENV DISCOURSE_VERSION 1.4.2
ENV RAILS42 1

RUN curl -L https://github.com/discourse/discourse/archive/v${DISCOURSE_VERSION}.tar.gz \
  | tar -xz -C /usr/src/app --strip-components 1 \
  && rm Gemfile.lock && bundle install  --without test --without development

RUN apt-get update && apt-get install -y --no-install-recommends imagemagick libxml2 \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y node-uglify advancecomp gifsicle jhead jpegoptim libjpeg-progs optipng pngcrush pngquant && rm -rf /var/lib/lists/*

ENV RAILS_ENV production
ENV DISCOURSE_DB_HOST postgres
ENV DISCOURSE_REDIS_HOST redis
ENV DISCOURSE_SERVE_STATIC_ASSETS true

EXPOSE 3000
CMD ["rails", "server", "--bind", "0.0.0.0"]
