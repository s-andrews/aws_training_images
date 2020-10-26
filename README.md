# AWS training images
A set of build scripts to generate AWS instances ready to run our training courses.

These are designed to work directly on AWS and some of the steps will be specific to that, but mostly these could also be used on a local instance of the correct operating system to set up a local environment.

Since these are designed for AWS they will generally assume that we start from a minimal install of the relevant operating system, but with all security patches applied.

## Building an image
Eventually we will make the output of these images available as EC2 AMI images so you will be able to spawn them directly.  For the moment though you'll have to build the complete server from a base image.

The steps to do this will be as follows:

1. Start a new EC2 instance using the name of the OS in the image name (eg CentOS7) to select the base image to start from.  You can set your desired amount of CPU / Memory / Disk but the images we use for training are using the t2.medium servers and 50GB storage.

2. Set a suitable security group.  You will need both SSH (TCP/UDP port 22) and HTTP (TCP/UDP port 80) access to the server.

3. Either create a new SSH key or use one you've created before.

4. Once the instance has started (it will take a couple of minutes, connect to the server using something like ```ssh -i my_key.pem centos@1.2.3.4```

5. Start by installing git using the OS package manager, on CentOS this would be ```sudo yum -y install git```. On ubuntu git is already there in the default image.

6. Clone the AWS training images repository ```git clone https://github.com/s-andrews/aws_training_images.git```

7. Move into the new repository folder ```cd aws_training_images```

8. Execute the script for the image you want to build. It's a good idea to do this as a nohup command and redirect the output to a log file ```nohup ./rstudio_server_centos7.sh > ~/build.log &```

9. Once the build is complete visit the IP of the server in a web browser (eg http://1.2.3.4)

For all servers which have a login the username will be **student** and the password will be the instance ID of the server you just built (which will be shown in your EC2 dashboard).
