VMware vSphere
================

Prerequisites
---------------

Terraform
^^^^^^^^^^^

Install Terraform according to the `guide <https://www.terraform.io/intro/getting-started/install.html>`_. 

Operating System
^^^^^^^^^^^

This configuration was tested on CentOS 7.1 x64.

VMware template
^^^^^^^^^^^^^^^^^

Create a template for the microservices cluster virtual machines. You will able to change CPU and RAM parameters while provisioning a virtual machine from template with Terraform. It's recommended to disable SELinux. Create user and add public RSA keys for SSH into the $HOME/.ssh/authorized_keys.
It is required to have VMware tools and deployPkg in the template, because we need to populate resulting ``.tfstate`` file with IP addresses of provisioned machines. With CentOS it is recommended to use ``open-vm-tools``::

   # yum install open-vm-tools -y

It is recommended to setup ``yum`` to install ``open-vm-tools-deploypkg``, as deployPkg is required to customize such things as ``hostname``.  Download the VMware packaging public keys from http://packages.vmware.com/tools/keys for ``yum``.

Install the KEYS::

   # rpm –import VMWARE-PACKAGING-GPG-DSA-KEY.pub
   # rpm –import /tmp/VMWARE-PACKAGING-GPG-RSA-KEY.pub
   # mkdir /etc/yum.repos.d/vmware-tools.repo
   # echo -e "[vmware-tools]\nname = VMware Tools\nbaseurl = http://packages.vmware.com/packages/rhel7/x86_64/\nenabled = 1\ngpgcheck = 1 >> /etc/yum.repos.d/vmware-tools.repo
   # yum install open-vm-tools-deploypkg
   # sudo systemctl restart vmtoolsd

If perl is not installed::
  
  # yum install perl gcc make kernel-headers kernel-devel -y 


Configuring vSphere for Terraform
-----------------------------------

See the example file in ``terraform/vsphere/main.tf``.  For full terraform settings see their documentation at https://terraform.io/docs/index.html, vSphere documentation is located under the Providers section.

Mantl specific settings
^^^^^^^^^^^^^^^^^^^^^^^

``control_count`` and ``worker_count`` are the number of nodes for specific roles.

``consul_dc`` the name of datacenter for Consul configuration.

``configuration_parameters`` are the custom parameters, for example specific service ``role``. 

Provisioning
--------------

Once you're all set up with the provider, customize your module, run ``terraform get`` to prepare Terraform to provision your cluster, ``terraform plan`` to see what will be created, and ``terraform apply`` to provision the cluster. At the end of provisioning Terraform will perform commands to change hostnames for correct service work. You can change this behavior in the ``provisioner`` section for each resource in the ``terraform/vsphere/main.tf`` file. 

Afterwards, you can use the instructions in :doc:`getting started <index>` to install microservices-infrastructure on your new cluster. 
