##
## Makefile to create *empty* Vagrant box for Parallels provider
##

VM_NAME ?= empty

all: ${VM_NAME}.box

%.box: etc/Vagrantfile etc/metadata.json
%.box: %.pvm
	tar -cvzf $@ $< -C etc Vagrantfile metadata.json 

%.pvm:
	prlctl create $@ \
		--ostype linux \
		--distribution rhel \
		--location ${PWD}

	prlctl set $@ \
		--cpus 2 \
		--memsize 4096 \
		--bios-type efi-arm64 \
		--device-set hdd0 --size 50000 \
		--startup-view headless

	prlctl unregister $@


clean:
	rm -rf ${VM_NAME}.box ${VM_NAME}.pvm

.PHONY: clean
.SECONDARY: %.pvm
