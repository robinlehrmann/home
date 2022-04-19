help:                                                                           ## shows this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_\-\.]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

ANSIBLE_PLAYBOOK_CMD = ansible-playbook -u root -i home

provision:                                               ## provision home server
	$(ANSIBLE_PLAYBOOK_CMD) playbooks/provision.yml

update:                                                  ## update home server
	$(ANSIBLE_PLAYBOOK_CMD) playbooks/update.yml

devbox-setup:                                            ## setup devbox
	vagrant up

devbox-update:                                           ## update devbox
	vagrant provision

.PHONY: provision update devbox-setup devbox-update
