# Use an official Node.js runtime as a parent image
FROM node:18-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json .

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the SvelteKit application
RUN npm run build

# Use a lightweight production container to serve the app
FROM node:18-alpine AS production

# Set the working directory inside the container
WORKDIR /app

# Copy the built files from the build stage
COPY --from=build /app/build build/
COPY --from=build /app/package.json .

# Install only production dependencies
RUN npm install --only=production

# Set the environment variable for runtime (optional)
ENV NODE_ENV=production

# Expose the port that your app will run on
EXPOSE 3000

# Command to run the application
CMD ["node", "build"]
