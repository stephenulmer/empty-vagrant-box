# Empty Vagrant Box

This project generates a completely empty Vagrant box for the Parallels provider.

## Creating the Empty Box

    make clean
    make

## Importing the Box into Vagrant

    vagrant box add --name slu/empty

## Using the Empty Box

This box obviously doesn't do much without some help. By adding some additional box configuration
in the Vagrantfile, you can use the empty system to practice installing.

This example adds a second and third CDROM (there is already one as part of the empty box):

    Vagrant.configure("2") do |config|
      config.vm.box = "slu/empty"
      config.vm.box_check_update = false
      config.vm.boot_timeout = 1800
      config.vm.synced_folder ".", "/vagrant", disabled: true
      config.ssh.insert_key = "false"

      config.vm.provider "parallels" do |prl|
        prl.check_guest_tools = false
        prl.customize "post-import", ["set", :id, "--device-add", "cdrom", "--image", "rhel-9.4-aarch64-dvd.iso", "--connect"]
        prl.customize "post-import", ["set", :id, "--device-add", "cdrom", "--image", "ks.iso", "--connect"]
        prl.customize "post-import", ["set", :id, "--startup-view", "window"]
      end
    end

Note that before the OS isinstalled, you don't want Vagrant to try things that need one, specifically:

- Replacing the Vagrant insecure key (it's not there)
- Setting up shared folders with the host (there are no tools in the empty box)

