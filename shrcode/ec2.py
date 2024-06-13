import boto3
import time
import os
 
# Initialize a session using Amazon EC2
ec2 = boto3.resource('ec2', region_name='us-east-1')  # Change the region as needed
ec2_client = boto3.client('ec2', region_name='us-east-1')
 
# Function to create a key pair
def create_key_pair(key_name, key_file_path):
    try:
        key_pair = ec2_client.create_key_pair(KeyName=key_name)
        
        # Save the private key to a file
        with open(key_file_path, 'w') as file:
            file.write(key_pair['KeyMaterial'])
        
        # Set the correct permissions
        os.chmod(key_file_path, 0o400)
        
        print(f"Key pair '{key_name}' created and saved to '{key_file_path}'")
    except Exception as e:
        print(f"An error occurred: {e}")
 
# Parameters
key_name = 'sptst-jenkins-key-pair'
key_file_path = f'{key_name}.pem'
 
# Create the key pair
create_key_pair(key_name, key_file_path)
 
# Create a security group
security_group = ec2.create_security_group(
    GroupName='sptst-jenkins_sg',
    Description='Security group for Jenkins server',
    VpcId='vpc-009d2b0c8d27ac21c'

)
 
# Add rules to the security group
security_group.authorize_ingress(
    IpPermissions=[
        {
            'IpProtocol': 'tcp',
            'FromPort': 22,
            'ToPort': 22,
            'IpRanges': [{'CidrIp': '0.0.0.0/0'}]
        },
        {
            'IpProtocol': 'tcp',
            'FromPort': 8080,
            'ToPort': 8080,
            'IpRanges': [{'CidrIp': '0.0.0.0/0'}]
        }
    ]
)
 
# User data script to install Jenkins
user_data_script = '''#!/bin/bash
sudo yum update -y
sudo yum install -y java-1.8.0-openjdk-devel
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
'''
 
# Launch the instance
instances = ec2.create_instances(
    ImageId='ami-08a0d1e16fc3f61ea',  # Change this to your preferred Amazon Linux 2 AMI ID
    MinCount=1,
    MaxCount=1,
    InstanceType='t3.medium',
    KeyName=key_name,
#SecurityGroupIds=[security_group.id],
    UserData=user_data_script,
    TagSpecifications=[
        {
            'ResourceType': 'instance',
            'Tags': [{'Key': 'Name', 'Value': 'sptst-Jenkins-Server'}]
        }
    ],
    NetworkInterfaces=[{
        'AssociatePublicIpAddress': True,
        'DeviceIndex': 0,
        'SubnetId': 'subnet-019f693594dc21c72',  # Replace with your subnet ID
'Groups': [security_group.id]
    }]
)
 
# Wait for the instance to enter the running state
instance = instances[0]
instance.wait_until_running()
 
# Reload the instance attributes
instance.load()
 
# Print the public DNS name
print(f'Jenkins server is running at http://{instance.public_dns_name}:8080')