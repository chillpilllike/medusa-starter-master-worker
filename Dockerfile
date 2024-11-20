# Use the official Node.js 18 image as the base
FROM node:latest

# Set environment variables to reduce Docker image size
ENV NODE_ENV=production

# Create and set the working directory
WORKDIR /app

# Add an argument for cache busting
#ARG CACHE_BUSTING_ARG=1

# Use the cache-busting argument in the wget URL to avoid Docker layer cache
#RUN wget -q -O medusa-config.ts "https://raw.githubusercontent.com/chillpilllike/green/refs/heads/main/medusa-config.ts?${CACHE_BUSTING_ARG}"

#RUN wget -q -O package.json https://raw.githubusercontent.com/chillpilllike/green/refs/heads/main/package.json

RUN yarn global add @medusajs/medusa-cli 

# Install system dependencies (if any are needed)
# RUN apk add --no-cache <your-system-dependencies>

# Copy package.json and package-lock.json or yarn.lock first for better caching

# Install dependencies
RUN yarn

# Copy the rest of the application code

RUN rm -rf .medusa/server

# Build the Medusa application
RUN yarn build

# Verify that the .medusa/server directory exists
RUN ls -la .medusa/server

# Set the working directory to .medusa/server to simplify CMD commands
WORKDIR /app/.medusa/server

# Expose port 9000, which is the default port for Medusa applications
EXPOSE 9000

# Define the default command to handle migrations and start the server
RUN yarn predeploy

CMD yarn predeploy && yarn start

# CMD ["sh", "-c", "yarn predeploy && yarn run start"]
