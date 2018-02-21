# boinc-client-docker
The BOINC client in a Docker container. The client can be accessed remotely or locally with any BOINC Manager.

## Supported tags and respective `Dockerfile` links
- [`latest`](https://github.com/BOINC/boinc-client-docker/blob/master/Dockerfile) (BOINC client)
- [`amd`, `opencl`](https://github.com/BOINC/boinc-client-docker/blob/amd/Dockerfile) (AMD OpenCL-savvy BOINC client)
- [`nvidia`](https://github.com/BOINC/boinc-client-docker/blob/nvidia/Dockerfile) (NVIDIA CUDA-savvy BOINC client)

## Usage
Before you create your container, you must decide on the type of networking you wish to use.

- `host` (recommended)
- `bridge`

### Host Networking (recommended)
#### Docker
```
docker run \
  -d \
  --name boinc \
  --device=/dev/input/mice:/dev/input/mice \
  -v /opt/appdata/boinc:/var/lib/boinc-client \
  -e BOINC_GUI_RPC_PASSWORD="123" \
  -e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc" \
  --network=host \
  boinc/client
```

#### Docker Compose
```
version: '2'
services:

  boinc:
    image: boinc/client
    container_name: boinc
    network_mode: host
    restart: always
    devices:
      - /dev/input/mice:/dev/input/mice
    volumes:
      - /opt/appdata/boinc:/var/lib/boinc-client
    environment:
      - BOINC_GUI_RPC_PASSWORD=123
      - BOINC_CMD_LINE_OPTIONS=--allow_remote_gui_rpc
```

### Bridge Networking
#### Docker
```
docker run \
  -d \
  --name boinc \
  --device=/dev/input/mice:/dev/input/mice \
  -v /opt/appdata/boinc:/var/lib/boinc-client \
  -e BOINC_GUI_RPC_PASSWORD="123" \
  -e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc" \
  -p 31416:31416 \
  boinc/client
```

#### Docker Compose
```
version: '2'
services:

  boinc:
    image: boinc/client
    container_name: boinc
    restart: always
    devices:
      - /dev/input/mice:/dev/input/mice
    ports:
      - 31416:31416
    volumes:
      - /opt/appdata/boinc:/var/lib/boinc-client
    environment:
      - BOINC_GUI_RPC_PASSWORD=123
      - BOINC_CMD_LINE_OPTIONS=--allow_remote_gui_rpc
```

## Parameters
The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.

-  `--device=/dev/input/mice:/dev/input/mice` The mouse device will be accessible within the container. The BOINC throw error without it.
- `-v /opt/appdata/boinc:/var/lib/boinc-client` The path where you wish BOINC to store its configuration data.
- `-e BOINC_GUI_RPC_PASSWORD="123"` The password what you need to use, when you connect to the BOINC client. 
- `-e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc"` The `--allow_remote_gui_rpc` command-line option allows connecting to the client with any IP address. If you don't want that, you can remove this parameter, but you have to use the `-e BOINC_REMOTE_HOST="IP"`.
- `-e BOINC_REMOTE_HOST="IP"` Replace the `IP` with your IP address. In this case you can connect to the clien only from this IP.
- `-p 31416:31416` Forwards port 31416 from the host to the container.

## Controlling the client
You can control your BOINC client remotely with BOINC manager.
`File menu > Select computer...`
- `Host name:` The IP address of the PC which runs the docker image. If you don't use the standard `31416` port, than you hava to use the IP:PORT format. 
- `Password:` Your chosen password.

If you want to control the client on the local machine, the "Host name" will be: `127.0.0.1`

## Docker Info
- How to build it yourself: `docker build -t boinc .`
- Shell access whilst the container is running: `docker exec -it boinc /bin/bash`
- Monitor the logs of the container in realtime: `docker logs -f boinc`
