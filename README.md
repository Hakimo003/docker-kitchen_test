# Ansible : Dockerfile - kitchen

This image is ideal for test-kitchen, with docker as driver, ansible as provisioner, and busser/serverspec as verifier.

This is mainly for Ansible as provisioner. If kitchen-ansible provisioner is used, you can choose not to install chef by setting `require_chef_for_busser` to `False`.

Example:
```
provisioner:
  name: ansible_playbook
  require_chef_for_busser: false
```

Default verifier of kitchen is busser, so by default kitchen will install Chef, just to use the embedded ruby and gem to install busser.

If you use other verifiers, Chef is not needed at all.

But if you still want to have the capability and simplicity to use busser, this image does it for you since it is based on `centos:latest` with `rvm, ruby, ansible, busser, rake, bundle, rspec-retry and serverspec` installed.

`.kitchen.yml` example:

```
---
driver:
  name: docker
  privileged: true


provisioner:
  name: ansible_playbook
  hosts: localhost
  require_ruby_for_busser: false
  require_chef_for_busser: false
  additional_copy_role_path: my_liste_roles
  ignore_paths_from_root:
    - .git

verifier:
  root_path: /opt/verifier

platforms:
  - name: name_of_image
    driver_config:
      image: my_image_docker
      provision_command:
        - sed -ri 's/^#?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
        - sed -ri 's/^#?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
        - sed -ri 's/^#?UsePAM .*/UsePAM no/' /etc/ssh/sshd_config
      run_command: "/usr/sbin/init"
      privileged: true
      use_sudo: false

suites:
  - name: name_of_my_suite
    provisioner:
      idempotency_test: false
      playbook: the_entry_playbook
      ansible_inventory: inventory_file
      additional_copy_role_path: my_specific_liste_roles

```
## Kitchen - Requirements

- since we mentioned in the `.kitchen.yml` file that are using docker for tests, the folder `Docker/Docker_kitchen` will help to build the `docker_kitchen:1.0` image as described in the `Dockerfile`.

## Kitchen - Commands

* Kitchen create: it just create the docker container/vm to run.
* Kitchen destroy: it will delete the containers/vm's created by kitchen.
* Kitchen converge: will run the playbooks and roles as mentioned in provision.
* Kitchen verify: will test the playbooks and roles as mentioned in the suites.
* Kitchen test: will create, converge, verify and destroy the containers.

## License

HACH

## Author Information

It was created in 2018 by [CHRIFI ALAOUI Hakim](https://github.com/Hakimo003/docker-kitchen_test)
