FROM node:18

WORKDIR /usr/src/app
COPY package*.json ./

# generated prisma files
COPY prisma ./prisma/

# COPY ENV variable
COPY .env ./

# COPY tsconfig.json file
COPY tsconfig.json ./

COPY . .

EXPOSE 3000
RUN yarn install
RUN yarn prisma generate

RUN yarn build
CMD yarn start