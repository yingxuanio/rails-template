FROM ccr.ccs.tencentyun.com/yingxuan/rails-base:1.2.1

ENV APP_PATH '/app'
ENV RAILS_ENV 'development'

VOLUME $APP_PATH
WORKDIR $APP_PATH

COPY Gemfile ./Gemfile
COPY Gemfile.lock ./Gemfile.lock
RUN bundle install --jobs 20 --retry 5

COPY package.json ./package.json
RUN yarn install

COPY . ./

EXPOSE 3000
CMD ["bash"]

# Metadata
LABEL org.label-schema.vendor="Ivan@Yingxuan" \
      org.label-schema.url="https://www.yingxuan.io" \
      org.label-schema.name="英选Rails基础模板" \
      org.label-schema.version="v1.1.0" \
      org.label-schema.docker.schema-version="1.0"
