## VirtualMachine ##
 
### What is VirtualMachine? ###

 VirtualMachine is a machine which shares hardware components with real machine. It allows us to run an operating inside another operating system. It uses the virtualization technology to accomplish this. We say this hypervisor. By using this technology, we can utilize the system resource efficently. It has two type of hupervisor such as

 > * Type 1
 > * Type 2

 Type 1 hypervisor is an OS. It runs as a stand alone operationg system. It provides various tools and management console to create, manage and run the VirtualMachine. There are so many vendor provides these kind of hypervisor. Some of them shareware and Some of them freeware. Type 2 hyperisor is an application which provides the place to run a virtual machine. Typically this kind of hypervisor runs inside the host machine where Virtual Machine runs. There are so many hypervisor available in the market. Some of them is freeware. In our case, we uses the Oracle VirtualMachine to create a OVF template. We use the VMWare EXSi 5 to run virtual machine.

### What is OVF? ###
 
 OVF acronym is open virtualization format which is used in various hypervisor. It is an archiving file which consist the virtualmachine configuration, virtualdisk and data. This format is supported by various hypervisor such VMware EXSi and Oracle virtualbox and so on. Its main purpose is that to take snapshot of the running virtual machine image. By using this snappshot, we can create N number of virtual machine with unique configuration and settings. 
 
### How to create OVF Template? ###

 To create a new ovf file you have to have following components.

 > * VirtualBox4.X and above

 Download and install latest version of virtualbox in your machine. To install a oracle virtualbox in your machine, you can follow two way. First you could use your system package manager or you could use download package from oracle virtualbox official site. Our recommentation is that to downlaod package from official sites. Because the system pacakge manager does not know latest update of the package, If you are not telling explicitly. You could install package by using package manager but the package would not be a latest version. On offical site, you can downlaod the package based on your operating system that currently you are using. Next step is to downlaod Ubuntu latest version from the ubuntu official site. Ubuntu 14.04 is latest version when I created this document. After downloading ubuntu iso file and after installing oracle virtualbox in your system to start your virtualbox.

 To select new button from the top navigation bar of your virtualbox. Next pop up window will open and ask to enter new virtualbox name. To type your machine name like "Syclops-ubuntu-13.04" and select type "Linux" from the drop down menu. When you select type "Linux" from the drop down menu, the version automatically will be selected as Ubuntu. After given the details which mentioned above and select "Next" button on pop up window. Next window will open and give memory size to 512MB which is enough to run a ubuntu server edition and select "Next" button. On next window click "Create" button and do not do anything on it.

 Next window will ask to choose hard drive file, you just leave default option and click "Next" button. On next window to leave default option and click "Next" button. On next window to choose the location where you have to store this machine image and choose the virtual hard disk size which is default 8GB. Our recommentation is 10GB, you can increase the size after creation of virtualmachine. Now virtual hardware is ready. In side bar of the virtualbox, you could see newly created virtual machine named "Syclops-ubuntu-13.04". To click right button of your mouse on machine which we have created then you could see the various option. To choose the start option then next window will open and ask you to choose startup disk which is iso file. To mention the iso file location that we have downloaded before and click the start button. Next os installation process will begin. To install operating system. After installing the os successfully and stop the virtual machine. To click file menu and select export appliance option then a window will open and choose the newly created virtualmachine. On next window, To leave the default option and click next. On next window to read instruction carefully on the windown and click the export button. After clicking the export button, you have to wait some time to finish the ova file creation. After creation of ova file and upload that file into your file server. You can use this ovf file while you will create virtualmachine on VMWare EXSi.


