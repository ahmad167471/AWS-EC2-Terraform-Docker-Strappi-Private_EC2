# ────────────────────────────────────────────────────────────────
# Production-ready Strapi Dockerfile
# Based on node:20-alpine – lightweight, secure, fast
# ────────────────────────────────────────────────────────────────

FROM node:20-alpine

# Install runtime dependencies for sharp (image processing library used by Strapi)
RUN apk add --no-cache vips

# Set working directory
WORKDIR /app

# Copy dependency files first → excellent layer caching
COPY package*.json ./

# Install ONLY production dependencies
# We use npm install instead of npm ci to avoid lockfile sync errors
RUN npm install --production --omit=dev

# Copy the entire application code
COPY . .

# Build the admin panel (very important – otherwise admin UI won't work)
RUN npm run build

# Expose Strapi's default port
EXPOSE 1337

# Force production environment
ENV NODE_ENV=production \
    HOST=0.0.0.0 \
    PORT=1337

# Start Strapi in production mode
CMD ["npm", "run", "start"]