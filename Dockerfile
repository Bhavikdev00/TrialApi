# Use an official Dart runtime as a parent image
FROM google/dart:2.15.0

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Run pub get to fetch dependencies

RUN pub get

# Expose the port on which your Dart application will run
EXPOSE 3000

# Specify the command to run your application
CMD ["dart", "my_server/lib/server.dart"]
