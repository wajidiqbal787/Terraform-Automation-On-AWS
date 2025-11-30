
import boto3
import os
import logging

logging.basicConfig(filename='/home/ec2-user/upload_log.txt',
                    level=logging.INFO,
                    format='%(asctime)s - %(message)s')

bucket_name = 'terraform-python-automation-99b56006'  # Replace with your Terraform-created S3 bucket name
folder_path = '/home/ec2-user/upload_files'

s3 = boto3.client('s3', region_name='us-east-1')

for file_name in os.listdir(folder_path):
    full_path = os.path.join(folder_path, file_name)
    if os.path.isfile(full_path):
        s3.upload_file(full_path, bucket_name, file_name)
        logging.info(f'Uploaded {file_name} to {bucket_name}')
        print(f'Uploaded {file_name} to {bucket_name}')
