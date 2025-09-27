# ---- Build stage ----
FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
# use pnpm if your project requires it
RUN corepack enable && pnpm install
COPY . .
RUN pnpm run build

# ---- Runtime stage ----
FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=build /app/dist ./dist
RUN npm install -g serve
EXPOSE 3000
CMD ["serve", "dist", "-l", "3000"]
