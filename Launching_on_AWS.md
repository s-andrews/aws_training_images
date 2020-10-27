Launching an AWS EC2 instance
=============================

If you want to run one of our images on Amazon AWS this is the set of instructions for how to do it.

1 Create an AWS account
-----------------------

Before you can launch a cloud instance you will need to sign up for an Amazon AWS account and provide your payment details.  Amazon will charge you per hour for the time that your instances are running, and you can close them down when you're finished.  The amount you are charged will depend on the specifications for the server you choose to launch.  For each course we'll state the minimum requirements to complete the course, but you can choose to set up a more powerful server if you want to try analysing your own data which is bigger than the sets we use for training.

You can sign up for an account at https://aws.amazon.com/

2 Go to your EC2 dashbord
-------------------------

To launch a new instance you need to go to https://console.aws.amazon.com which is your EC2 dashboard.

AWS is split into different global geographic regions, so before you go any further you should select the region in which you want to launch your instance.  You generally want to pick whichever one is closest to you.  You will find that you probably start off in a North American zone, so you may well need to change this.  From the top menu pick the zone which is closest to you.

Note that all listings of running instances / volumes are split by zone, so you have to select the correct zone to see what you have running.  It can be easy to accidentally leave a server running in a different zone.

3 Launch a new instance
-----------------------

Next you need to select "Launch a virtual machine on EC2" to start creating your new instance.  This process is divided into several steps and we'll go through these individually.

### Select your base image
All EC2 instances are built off a base image.  You need to select the correct base image for the course you want to build.  The name of the course includes the base image name.  For example ```rnaseq_ubuntu_20.04.sh``` uses the Ubunto 20.04 image, and ```rstudio_server_centos7.sh``` uses the CentOS 7 base image.

To find your base image select **AWS Marketplace** in the menu on the left then type the first word of the image name (eg ```centos``` or ```ubuntu``` into the search box and press return.  Find the image you want and press the select button to select it.

You will then see a list of prices for different server types for that image.  All of the base images we use do not charge for the use of the software (you should see the software costs are all zero), only for the EC2 compute power and storage.  If you see charges for software at this stage then go back and check since you've selected the wrong image.

Press the continue button to move to the next step.

### Select the instance type ###

You can then select the power of the server you want to run your instance.  You'll see a list of configurations with names like ```t2.medium``` where they differ based on the number of CPUs they have and the amount of memory.  For each of our courses we'll tell you the minimum specification of server you need to use, but you are free to use a better one than that if you prefer.

Importantly, when you've selected the configuration **don't** press the "Review and Launch" button - press the grey "Configure Instance Details" button instead since there are other things you'll need to change.

### Add a configuration script ###

On the next screen "Configure instance details" you can ignore pretty much all of the settings on there.  What you do need to do is to scroll down to the "Advanced Details" section and the "User data" text box.  Into this box you can paste instructions which run when the server is started to configure it.  At the end of this document we have provided for each course image the script you need to paste into this box to get it to configure itself correctly.  If you don't add the correct script to this box then the instance won't configure itself when it starts.

When you've done this press the "Add Storage" button at the bottom.

### Add storage ###

The next screen allows you to specify the size of disk which you want to use on your server.  As with the CPU power we will tell you the minimum amount of storage (in Gigabytes) which you need to add, but you are free to increase this number if you like.  Part of the charge for the server is based around how much storage you use so adding a bigger disk will make the instance more expensive to run.

When you're finished you can press the "Add Tags" button, and then skip the next screen and press the "Configure Security Group" section.

### Configure security ###








