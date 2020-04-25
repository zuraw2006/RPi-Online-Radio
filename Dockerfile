FROM ruby:2.7-slim-buster

RUN set -eux; \
	apt-get update && apt-get install -y --no-install-recommends \
	moc \
	moc-ffmpeg-plugin \
	redis-server \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 4567

ENTRYPOINT ["sh", "docker-entrypoint.sh"]