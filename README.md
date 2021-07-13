# Chia plotter and blockchain network setup -- ubuntu

## Requirements

* ansible >= 2.9 -- install using pip or package manager

## Setup

Install requirements using ansible-galaxy -- `ansible-galaxy install -r requirements.yml`

## Run playbook

* Create inventory file with desired hosts
* Run `setup.yml` against hosts -- `ansible-playbook -i hosts setup.yml --ask-become-pass`

### Partial playbook run

You can use tags to select specific parts of playbook.

To update blockchain use `ansible-playbook -i hosts setup.yml --tags blockchain --ask-become-pass`

To update plotter use `ansible-playbook -i hosts setup.yml --tags plotter --ask-become-pass`
