FROM ruby:2.5

RUN gem install nokogiri -v1.6.3.1 -- --use-system-libraries=true --with-xml2-include="$(xcrun --show-sdk-path)"/usr/include/libxml2
RUN brew install postgresql@9.6

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

COPY . /myapp

EXPOSE 3000

# Start server
CMD ["rails", "s"]