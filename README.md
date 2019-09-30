# irohaboard-docker

## Overview

You can set up iroha Board with docker-compose.

For details of iroha Board, https://irohaboard.irohasoft.jp/

## Setup

Clone repository.

```
$ git clone https://github.com/suito01/irohaboard-docker.git
```

Start the container with docker-compose.

```
$ docker-compose up -d
```

Open a browser and enter "http://(your docker machine IP)/install" in the address field to set up iroha Board.

## Notice

It takes a few minutes to set up mysql. If a connection error occurs, wait for a while after starting the container and try accessing the setup page.