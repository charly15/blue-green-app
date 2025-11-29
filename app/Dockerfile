FROM node:18-alpine

WORKDIR /app

# Copiar package.json e instalar dependencias
COPY package.json ./
RUN npm install --production

# Copiar código fuente
COPY src ./src

EXPOSE 3000

CMD ["node", "src/server.js"]
