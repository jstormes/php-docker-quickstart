# php-docker-quickstart
A project template that works with PhpStorm and Docker for PHP for 
development.

## Quick start

This project is a template for a PHP projects using Docker. 
It is meant to be a starting point for a PHP project using Docker.
You should replace this readme and code with your own.
You should fork or copy from this project and make it your own.

Make sure you have Docker Desktop installed and running.

### Debugging with PhpStorm and xDebug Helper browser Extension

To debug PHP web code with PhpStorm, you need to install the xDebug Helper
Extension.

[https://chromewebstore.google.com/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc?hl=en]

[https://microsoftedge.microsoft.com/addons/detail/xdebug-helper/ggnngifabofaddiejjeagbaebkejomen?hl=en-US]

[https://addons.mozilla.org/en-US/firefox/addon/xdebug-helper-for-firefox/]

Then set up the helper under Extension->Xdebug Helper `details` then `extension options`.

IDE key: `PHPSTORM`

Trace Trigger Value: `XDEBUG_TRACE`

Profile Trigger Value: `XDEBUG_PROFILE`

Use `[ctrl][shift][x]` or click the bug icon on the toolbar, the select `debug` to trigger debugging.

Set up a Docker Server in PhpStorm:

- `[ctrl][alt][s]`
- Build, Execution, Deployment->Docker
- Click the `+` button and select `Docker`
- Name: `Docker`

Build and Run the Docker server:

- Run->Run `Build Interactive`

Open the web page http://localhost:8088 in your browser.

To Debug PHP code:

- in PhpStorm, click the "bug" icon in the upper right corner of the window to start listening for xDebug connections.
- in the browser, click the xDebug Helper icon and select `debug` to start debugging.
- in PhpStorm, set a breakpoint in your PHP code and refresh the page.
- PhpStorm should stop at the breakpoint.
- Or you can use Run->break at first line to start debugging on the first line of the code.
- To Stop debugging, click on the "bug" icon in the browser and select `Disable`, and/or click the "bug" icon in PhpStorm.


## To (re)build a production image

To build a production image, Run->Run `Build Prod`.

Unlike the development image, the production image must be built before changes
to the code will be reflected in the running container.

## To access the production image locally

Open your browser to [http://localhost:9088](http://localhost:9088/).

## To publish the production image

Edit the lines in `docker-compose.yml` that specify the `image:` name to
match your Docker Hub account and repository.

To push the production image to Docker Hub, run 
`docker compose push php-prod` from the project root directory.

## Production hosting

https://www.hostingadvice.com/how-to/best-docker-container-hosting/


## To access the development Database

If you have not done so already, start the Docker containers Run->Run `Build Interactive`.

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

