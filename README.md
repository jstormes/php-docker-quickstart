# php-docker-quickstart
A project template that works with PhpStorm and Docker for PHP for 
development.

## Quick start

This project is a template for a PHP projects using Docker. 
It is meant to be a starting point for a PHP project using Docker.
You should replace this readme and code with your own.
You should fork this project and make it your own.

Make sure you have Docker and Docker Compose installed.

## To start the PHP dev server (CLI)

From the directory root of the project run `docker compose up` to 
start the PHP server.

Then open your browser to [http://localhost:8088](http://localhost:8088/).

You can change the code in the `app` directory and the changes will be
reflected in the browser.

To remove the Docker containers, from the Docker CLI windows press 
[Control]-C and then run `docker compose down`.

### Debugging with PhpStorm and xDebug Helper Chrome Extension

To debug PHP code with PhpStorm, you need to install the xDebug Helper
Extension.

[https://chromewebstore.google.com/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc?hl=en]

[https://microsoftedge.microsoft.com/addons/detail/xdebug-helper/ggnngifabofaddiejjeagbaebkejomen?hl=en-US]

Then set up the helper under Extension->Xdebug Helper `details` then `extension options`.

IDE key: `PHPSTORM`

Trace Trigger Value: `XDEBUG_TRACE`

Profile Trigger Value: `XDEBUG_PROFILE`

Use [ctrl][shift][x] the select `debug` to trigger debugging.

In PhpStorm, set up a new PHP Remote Debug configuration.

- Run->Edit Configurations
- Click the `+` button and select `PHP Remote Debug`
- Name: `PHP Remote Debug`
- Server: `Docker`
- IDE key: `PHPSTORM`
- Click `OK`

Open your browser to the page under development, then set a breakpoint in your PHP code and refresh the page.

Or you can use Run->break at first line to start debugging to start on page refresh.

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

Edit the lines in `docker-compose.yml` that specify the `image:` name to
match your Docker Hub account and repository.

To push the production image to Docker Hub, run 
`docker compose push php-prod`.

## Production hosting

https://www.hostingadvice.com/how-to/best-docker-container-hosting/








