TAGS=.latest .nvidia-cuda .opencl .virtualbox

build:
	for TAG in ${TAGS}; do \
		docker build -t boinc/client:$${TAG#.}  -f Dockerfile$${TAG#.latest} . ; \
	done

push:
	for TAG in ${TAGS}; do \
		docker push boinc/client:$${TAG#.} ; \
	done
