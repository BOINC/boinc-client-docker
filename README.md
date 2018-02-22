# boinc-client-docker

The BOINC client in a Docker container. The client can be accessed remotely or locally with any BOINC Manager.


## Usage

The following command runs the BOINC client Docker container,

```
docker run -d \
  --name boinc \
  --device=/dev/input/mice:/dev/input/mice \
  --net=host \
  -v /opt/appdata/boinc:/var/lib/boinc-client \
  -e BOINC_GUI_RPC_PASSWORD="123" \
  -e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc" \
  boinc/client
```

You can attach a BOINC Manager to the client by launching the BOINC Manager, going to `File > Select computer...`, and entering the IP address of the PC running the Docker container in the "Host name" field (`127.0.0.1` if running locally) as well as the password you set with `BOINC_GUI_RPC_PASSWORD` (here `123`),

![manager_connect](manager_connect.png)

As usual, the client can also be controlled from the command line via the `boinccmd` command. 

From the same computer as the one which is running the Docker container, you can issue commands via,

```
docker exec boinc boinccmd <args>
```

From other computers, you should use instead,

```
docker run --rm boinc/client boinccmd --host <host> --passwd 123 <args>
```

where `<host>` should be the hostname or IP address of the machine running the Docker container. 

You are also free to run `boinccmd` natively if you have it installed, rather than via Docker. 


## Other tags

You can append any of the following tags to the image name in the above commands (e.g. `boinc/client:amd` or `boinc/client:nvidia` instead of just `boinc/client`) to use one of the other available container flavors,

- `amd` (AMD savvy BOINC client)
- `opencl` (OpenCL-savvy BOINC client)
- `nvidia` (NVIDIA CUDA-savvy BOINC client)


## Parameters

When running the client, the following parameters are available (split into two halves, separated by a colon, the left hand side representing the host and the right the container side),

- `--device=/dev/input/mice:/dev/input/mice` The mouse device will be accessible within the container. The BOINC throw error without it.
- `-v /opt/appdata/boinc:/var/lib/boinc-client` The path where you wish BOINC to store its configuration data.
- `-e BOINC_GUI_RPC_PASSWORD="123"` The password what you need to use, when you connect to the BOINC client. 
- `-e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc"` The `--allow_remote_gui_rpc` command-line option allows connecting to the client with any IP address. If you don't want that, you can remove this parameter, but you have to use the `-e BOINC_REMOTE_HOST="IP"`.
- `-e BOINC_REMOTE_HOST="IP"` Replace the `IP` with your IP address. In this case you can connect to the client only from this IP.


## Docker Compose
You can create the following `docker-compose.yml` file and from within the same directory run the client with `docker-compose up -d` to avoid the longer command from above. 
```
version: '2'
services:

  boinc:
    image: boinc/client
    container_name: boinc
    restart: always
    network_mode: host
    devices:
      - /dev/input/mice:/dev/input/mice
    volumes:
      - /opt/appdata/boinc:/var/lib/boinc-client
    environment:
      - BOINC_GUI_RPC_PASSWORD=123
      - BOINC_CMD_LINE_OPTIONS=--allow_remote_gui_rpc
```


## More Info
- How to build it yourself: `docker build -t boinc .`
- Shell access whilst the container is running: `docker exec -it boinc /bin/bash`
- Monitor the logs of the container in realtime: `docker logs -f boinc`
