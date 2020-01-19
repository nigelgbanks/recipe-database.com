####################################
# Base Image                       #
####################################
FROM node:12.14.1-alpine3.11 as base
RUN apk add --no-cache tini
WORKDIR /app
ENTRYPOINT ["/sbin/tini", "--"]
COPY package.json yarn.lock /app/

####################################
# Prod Image                       #
####################################
FROM base AS prod
RUN yarn install \
    --prod \
    --frozen-lockfile 

####################################
# Dev Image                        #
####################################
FROM prod as dev
RUN yarn install

####################################
# Test Image                       #
####################################
FROM dev as test
COPY . .
#RUN yarn run lint && yarn run test

####################################
# App Image                        #
####################################
FROM prod as app
COPY . .
EXPOSE 3000
CMD npm run start