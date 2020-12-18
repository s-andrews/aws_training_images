Launching an AWS EC2 instance
=============================

If you want to run one of our images on Amazon AWS this is the set of instructions for how to do it.

**Please note, running cloud services is NOT FREE and you will be charged per hour for running one of these images. Our standard training image costs around £1 per day to run on Amazon EC2**

1 Create an AWS account
-----------------------

Before you can launch a cloud instance you will need to sign up for an Amazon AWS account and provide your payment details.  Amazon will charge you per hour for the time that your instances are running, and you can close them down when you're finished.  The amount you are charged will depend on the specifications for the server you choose to launch.  For each course we'll state the minimum requirements to complete the course, but you can choose to set up a more powerful server if you want to try analysing your own data which is bigger than the sets we use for training.

You can sign up for an account at https://aws.amazon.com/

2 Go to your EC2 dashbord
-------------------------

To launch a new instance you need to go to https://console.aws.amazon.com which is your EC2 dashboard.

AWS is split into different global geographic regions, so before you go any further you should select the region in which you want to launch your instance.  You generally want to pick whichever one is closest to you.  You will find that you probably start off in a North American zone, so you may well need to change this.  From the top menu pick the zone which is closest to you.

![AWS Zone List](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/ec2_zone_list.png)

Note that all listings of running instances / volumes are split by zone, so you have to select the correct zone to see what you have running.  It can be easy to accidentally leave a server running in a different zone.

3 Launch a new instance
-----------------------
Next you need to select "Launch a virtual machine" to start creating your new instance.  This process is divided into several steps and we'll go through these individually.

![Launch VM](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/launch_ec2.png)


### Select your base image
All EC2 instances are built off a base image.  You need to select the correct base image for the course you want to build.  The name of the course includes the base image name.  For example ```rnaseq_ubuntu_20.04.sh``` uses the Ubunto 20.04 image, and ```rstudio_server_centos7.sh``` uses the CentOS 7 base image.

To find your base image select **AWS Marketplace** in the menu on the left then type the first word of the image name (eg ```centos``` or ```ubuntu``` into the search box and press return.  Find the image you want and press the select button to select it.

![Base Image](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/base_image_selection.png)
![Base Image](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/base_image_selection_centos.png)

You will then see a list of prices for different server types for that image.  All of the base images we use do not charge for the use of the software (you should see the software costs are all zero), only for the EC2 compute power and storage.  If you see charges for software at this stage then go back and check since you've selected the wrong image.

Press the continue button to move to the next step.

### Select the instance type ###

You can then select the power of the server you want to run your instance.  You'll see a list of configurations with names like ```t2.medium``` where they differ based on the number of CPUs they have and the amount of memory.  For each of our courses we'll tell you the minimum specification of server you need to use, but you are free to use a better one than that if you prefer.

![Instance Type](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/instance_type_selection.png)

Importantly, when you've selected the configuration **don't** press the "Review and Launch" button - press the grey "Configure Instance Details" button instead since there are other things you'll need to change.

### Add a configuration script ###

On the next screen "Configure instance details" you can ignore pretty much all of the settings on there.  What you do need to do is to scroll down to the "Advanced Details" section and the "User data" text box.  Into this box you can paste instructions which run when the server is started to configure it.  At the end of this document we have provided for each course image the script you need to paste into this box to get it to configure itself correctly.  If you don't add the correct script to this box then the instance won't configure itself when it starts.

![Configuration Script](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/advanced_details.png)

When you've done this press the "Add Storage" button at the bottom.

### Add storage ###

The next screen allows you to specify the size of disk which you want to use on your server.  As with the CPU power we will tell you the minimum amount of storage (in Gigabytes) which you need to add, but you are free to increase this number if you like.  Part of the charge for the server is based around how much storage you use so adding a bigger disk will make the instance more expensive to run.

![Add Storage](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/add_storage.png)

When you're finished you can press the "Add Tags" button, and then skip the next screen and press the "Configure Security Group" section.

### Configure security ###
The next screen will set up the firewall for your instance.  You need to say what traffic is allowed to get to your new server.  By default your server will only be accessible by SSH, which you don't strictly need (but which might be useful) but you need to make it accessible via HTTP so you can point a web browser to it.

To add the new rule press the "Add Rule" button, then in the Type drop-down select HTTP.  This should be all you need.  Once this is done you can select "Review and Launch" to move to the final checks.

![Security Rules](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/security_rules.png)

### Launch the server ###

From the review page you can quickly check all of the settings you made and once you're happy you can select "Launch" to start the server.

Before you can launch the server Amazon will make you set up an SSH key which will allow you to log directly in to the server for troubleshooting.  You probably won't need to use this if you're just using the image to run a course, but it's a good idea to have this just in case.  If you've created a key before then you can just select it, but if you haven't then you'll need to make a new key and give it a name.  It will then make you download the key (.pem) file which you should save somewhere safe.

![New Key](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/create_new_key.png)

![Existing Key](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/select_existing_key.png)

Finally you can press "Launch" to start the server.  You will be taken to a screen where you can see the name of the instance which was created.  

![Instances Launching](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/instances_launching.png)

You can click on the instance name to be taken to your EC2 dashboard where you will see the details of the instance.  Initially a filter will be set where you can only see the newly launched instance, but you can press the "Clear Filters" button to see all of your instances in this AWS zone.

![Instance List](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/instance_list.png)

Your server is now running and the build scripts will start to set everything up.  Depending on the image you choose it may take anything from 5 to 30 minutes to complete configuring the server and downloading all of the data you'll need.

4 Connect to your new instance
------------------------------

Although your server will move to a "Running" state very quickly, it will take a little time to add the software which allows you to connect to the web interface so be a little patient.

To connect to the server you need to copy the IP address from your EC2 dashboard and paste it into your browsers location bar.  You should then see a login page which will look something like one of those shown below.  To log in to the server use the following credentials:

* **Username**: ```student```
* **Password**: ```[The instance ID for your server]```

You can copy both of these from your EC2 dashboard.  Once you've logged in you should then see the main interface for your environment.

5 Shutting down your instance
-----------------------------

You will be charged by the hour for the instances you launch, whether or not you are actively making use of them.  You should therefore shut down the servers as soon as you are finished with them.

To shut down an instance go to your EC2 dashboard, find the server you're finished with, right click on it and select "Terminate Instance".  You will have to confirm this, and then your server will be closed down.  You will still see it listed in your dashboard for a short while, but with a state of "Terminated"

![Terminate Instance](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/terminate_instance.png)

![Are you sure](https://raw.githubusercontent.com/s-andrews/aws_training_images/main/docs/terminate_are_you_sure.png)

Course Configurations
=====================

Listed below are the settings you need to use for your "User data" when building an image for different courses.  We'll also state the minimum server type and disk size.

RNA-Seq
-------

* **Base Image**: Ubuntu 20.04 LTS - Focal
* **Server Type**: t2.medium
* **Disk Size**: 20GB

### User Data
```
#!/bin/bash
git clone https://github.com/s-andrews/aws_training_images.git
cd aws_training_images
nohup ./rnaseq_ubuntu_20.04.sh > ~/build.log &
```

ChIP-Seq
-------

* **Base Image**: Ubuntu 20.04 LTS - Focal
* **Server Type**: t2.medium
* **Disk Size**: 20GB

### User Data
```
#!/bin/bash
git clone https://github.com/s-andrews/aws_training_images.git
cd aws_training_images
nohup ./chip_ubuntu_20.04.sh > ~/build.log &
```


R Courses
---------
The same configuration is used for the Introduction to R, Advanced R and GGplot courses.  A separate configuration is used for the Shiny course.

* **Base Image**: CentOS 7 (x86_64) - with Updates HVM
* **Server Type**: t2.medium
* **Disk Size**: 20GB

### User Data
```
#!/bin/bash
sudo yum -y install git
git clone https://github.com/s-andrews/aws_training_images.git
cd aws_training_images
nohup ./rbootcamp_centos7.sh > ~/build.log &
```

10X Courses
---------
This image can be used for the final Seurat exercise for the 10X course

* **Base Image**: CentOS 7 (x86_64) - with Updates HVM
* **Server Type**: t2.large
* **Disk Size**: 20GB

### User Data
```
#!/bin/bash
sudo yum -y install git
git clone https://github.com/s-andrews/aws_training_images.git
cd aws_training_images
nohup ./r10x_centos7.sh > ~/build.log &
```


Introduction to Unix
---------------------

* **Base Image**: Ubuntu 20.04 LTS - Focal
* **Server Type**: t2.medium
* **Disk Size**: 20GB

### User Data
```
#!/bin/bash
sudo yum -y install git
git clone https://github.com/s-andrews/aws_training_images.git
cd aws_training_images
nohup ./unix_intro_ubuntu_20.04.sh > ~/build.log &
```









