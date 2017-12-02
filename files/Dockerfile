# From base image
FROM ccr.ccs.tencentyun.com/yingxuan/rails-base:1.0.1

ARG APP_PATH='/app'
ENV PORT=3000
ENV RAILS_ENV 'development'

RUN mkdir $APP_PATH
WORKDIR $APP_PATH
COPY . ./

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install nodejs yarn
RUN bundle install --jobs 20 --retry 5
RUN yarn install

EXPOSE $PORT
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

# Metadata
LABEL org.label-schema.vendor="Ivan@Yingxuan" \
      org.label-schema.url="https://www.yingxuan.io" \
      org.label-schema.name="英选Rails基础模板" \
      org.label-schema.version="v1.1.0" \
      org.label-schema.docker.schema-version="1.0"
