# Étape 1 — Build avec Node
FROM node:20-alpine AS build
WORKDIR /app

# Copie package.json et installation
COPY package*.json ./
RUN npm install

# Copie du code source
COPY . .

# Build de l'app pour production
RUN npm run build

# Étape 2 — Serveur Nginx
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html

# Supprime le contenu par défaut de Nginx
RUN rm -rf ./*

# Copie les fichiers buildés depuis l’étape précédente
COPY --from=build /app/dist ./

# Copie une config Nginx custom pour SPA
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
