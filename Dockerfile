#             node block
# Use an official Node runtime as a parent image
FROM node:16-alpine as demoapp

# Set the working directory in the container
WORKDIR /nodejs

# Copy package.json and package-lock.json
COPY package*.json ./

# Install any needed packages specified in package.json
RUN npm install

# Copy the rest of the client's source code
COPY . .

# Build the application for production
RUN npm run build

#             nginx block
# Use the Nginx image to serve the React application
FROM nginx:alpine

# Copy the build output to replace the default nginx contents.
COPY --from=demoapp /nodejs/build /usr/share/nginx/html

# Expose port 80 to the Docker daemon.
EXPOSE 80

# Start Nginx and serve the application
CMD ["nginx", "-g", "daemon off;"]
