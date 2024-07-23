# php-docker-quickstart
A starting project works with PhpStorm for using Docker for PHP for 
development

## Quick start

This project is just a template for a PHP project using Docker. 
It is meant to be a starting point for a PHP project using Docker.
You should replace this readme and code with your own.
You should fork this project and make it your own.

Start by cloning this repository to your local machine.

Make sure you have Docker and Docker Compose installed.

## To start the PHP dev server

From the directory root of the project run `docker compose up` to 
start the PHP server.

Then open your browser to [http://localhost:8088](http://localhost:8088/).

To remove the Docker containers, from the Docker CLI windows press 
[Control]-C and then run `docker compose down`.

## To access the development Database

If you have not done so already, start the Docker containers by running
`docker compose up`.

By default, PhpMyAdmin is available at 
[http://localhost:7088](http://localhost:7088/).

To access the database from outside the Docker container, you can use
a database client like MySQL Workbench or DBeaver.  
Use the following connection information:

- Host: `localhost`
- Port: `5000`
- Username: `root`
- Password: `password`
- Database: `app`

## To (re)build a production image

To build a production image, run 
`docker compose build php-prod`.

## To access the production image locally

To open a browser to the production image, run
`docker compose up php-prod`.

Then open your browser to [http://localhost:9088](http://localhost:9088/).

To stop and remove the production image, press [Control]-C and then run
`docker compose down`.

## To publish the production image

To publish the production image to Docker Hub, run 
`docker compose push php-prod`.

## Production hosting

https://www.hostingadvice.com/how-to/best-docker-container-hosting/








