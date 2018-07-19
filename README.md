# BOINC client in a Docker container

The client can be accessed remotely or locally with any BOINC Manager.


## Usage

The following command runs the BOINC client Docker container,

```
docker run -d \
  --name boinc \
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


## Other versions

You can replace `boinc/client` above with either of the following tags to use one of the specialized container versions instead.

- [`boinc/client:intel`](Dockerfile.intel) Intel GPU-savvy BOINC client. It supports Broadwell (5th generation) CPUs and beyond. Check the usage [below](https://github.com/BOINC/boinc-client-docker#intel-gpu-savvy-boinc-client-usage).
- [`boinc/client:intel-legacy`](Dockerfile.intel-legacy) Legacy Intel GPU-savvy BOINC client (Sandybridge - 2nd Gen, Ivybridge - 3rd Gen, Haswell - 4th Gen). Check the usage [below](https://github.com/BOINC/boinc-client-docker#legacy-intel-gpu-savvy-boinc-client-usage).
- [`boinc/client:nvidia`](Dockerfile.nvidia) - NVIDIA-savvy (CUDA & OpenCL) BOINC client. Check the usage [below](https://github.com/BOINC/boinc-client-docker#nvidia-savvy-boinc-client-usage).
- [`boinc/client:multi-gpu`](Dockerfile.multi-gpu) - Intel & Nvidia-savvy BOINC client. Check the usage [below](https://github.com/BOINC/boinc-client-docker#multi-gpu-savvy-boinc-client-usage).
- [`boinc/client:virtualbox`](Dockerfile.virtualbox) - VirtualBox-savvy BOINC client. Check the usage [below](https://github.com/BOINC/boinc-client-docker#virtualbox-savvy-boinc-client-usage).
- [`boinc/client:opencl`](Dockerfile.opencl) - AMD OpenCL-savvy BOINC client.


### Intel GPU-savvy BOINC client usage
- Install the Intel GPU Driver.
- Run the following command:
```
docker run -d \
  --name boinc \
  --device /dev/dri:/dev/dri \
  --net=host \
  -v /opt/appdata/boinc:/var/lib/boinc-client \
  -e BOINC_GUI_RPC_PASSWORD="123" \
  -e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc" \
  boinc/client:intel
```

### Legacy Intel GPU-savvy BOINC client usage
- Install the Intel GPU Driver.
- Run the following command:
```
docker run -d \
  --name boinc \
  --device /dev/dri:/dev/dri \
  --net=host \
  -v /opt/appdata/boinc:/var/lib/boinc-client \
  -e BOINC_GUI_RPC_PASSWORD="123" \
  -e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc" \
  boinc/client:intel-legacy
```

### NVIDIA-savvy BOINC client usage
- Make sure you have installed the [NVIDIA driver](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#how-do-i-install-the-nvidia-driver).
- Install the NVIDIA-Docker version 2.0 by following the instructions [here](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)).
- Run the following command:
```
docker run -d \
  --runtime=nvidia \
  --name boinc \
  --net=host \
  -v /opt/appdata/boinc:/var/lib/boinc-client \
  -e BOINC_GUI_RPC_PASSWORD="123" \
  -e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc" \
  boinc/client:nvidia
```

### Multi GPU-savvy BOINC client usage
- Make sure you have installed the [NVIDIA driver](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#how-do-i-install-the-nvidia-driver).
- Install the NVIDIA-Docker version 2.0 by following the instructions [here](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)).
- Run the following command:
```
docker run -d \
  --runtime=nvidia \
  --name boinc \
  --device /dev/dri:/dev/dri \
  --net=host \
  -v /opt/appdata/boinc:/var/lib/boinc-client \
  -e BOINC_GUI_RPC_PASSWORD="123" \
  -e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc" \
  boinc/client:multi-gpu
```


### VirtualBox-savvy BOINC client usage

- Install the `virtualbox-dkms` package on the host.
- Run the following command:
```
docker run -d \
  --name boinc \
  --device=/dev/vboxdrv:/dev/vboxdrv \
  --net=host \
  -v /opt/appdata/boinc:/var/lib/boinc-client \
  -e BOINC_GUI_RPC_PASSWORD="123" \
  -e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc" \
  boinc/client:virtualbox
```

## Swarm mode

You can use a Docker Swarm to launch a large number of clients, for example across a cluster that you are using for BOINC computation. First, start the swarm and create a network,

```
docker swarm init
docker network create -d overlay --attachable boinc
```

If you want, you can connect other nodes to your swarm by running the appropriate `docker swarm join` command on worker nodes as prompted above (although you can just run on one node too).

Then launch your clients,
```
docker service create \
  --replicas <N> \
  --name boinc \
  --network=boinc \
  -p 31416 \
  -e BOINC_GUI_RPC_PASSWORD="123" \
  -e BOINC_CMD_LINE_OPTIONS="--allow_remote_gui_rpc" \
  boinc/client
```

You now have `<N>` clients running, distributed across your swarm. You can issue commands to all of your clients via, 

```
docker run --rm --network boinc boinc/client boinccmd_swarm --passwd 123 <args>
```

Note you do not need to specify `--host`. The `boinccmd_swarm` command takes care of sending the command to each of the hosts in your swarm. 


## Parameters

When running the client, the following parameters are available (split into two halves, separated by a colon, the left hand side representing the host and the right the container side),

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
    volumes:
      - /opt/appdata/boinc:/var/lib/boinc-client
    environment:
      - BOINC_GUI_RPC_PASSWORD=123
      - BOINC_CMD_LINE_OPTIONS=--allow_remote_gui_rpc
```


## More Info
- How to build it yourself: `docker build -t boinc/client .`
- Shell access whilst the container is running: `docker exec -it boinc /bin/bash`
- Monitor the logs of the container in realtime: `docker logs -f boinc`
