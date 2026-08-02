# Use Node.js Alpine base image
FROM node:alpine AS builder

# Create and set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json /app/

# Install dependencies
RUN npm install

# Copy the entire codebase to the working directory
COPY . /app/

#Stage 2 RUNTIME
FROM node:alpine

# Create and set the working directory inside the container
WORKDIR /app
# Reduce the size
RUN npm install --omit=dev

#Copy from 1 stage
COPY --from=builder /app .

# Expose the port your container app
EXPOSE 3000    

# Define the command to start your application (replace "start" with the actual command to start your app)
CMD ["npm", "start"]
