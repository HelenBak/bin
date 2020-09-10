# 
# https://swalloow.github.io/aws-cli-mfa/
#
#! /bin/bash
#setProfile() {
#  export AWS_PROFILE=$1
#  export AWS_DEFAULT_PROFILE=$1
#
#  python ~/.aws/mfa.py --profile $1 $2
#}
#alias awsp=setProfile

import os
import json
import sys
import argparse
import subprocess
import configparser

parser = argparse.ArgumentParser(description='Update your AWS CLI Token')
parser.add_argument('token', help='token from your MFA device')
parser.add_argument('--profile', help='aws profile to store the session token', default=os.getenv('AWS_PROFILE'))
parser.add_argument('--arn', help='AWS ARN from the IAM console (Security credentials -> Assigned MFA device). This is saved to your .aws/credentials file')
parser.add_argument('--credential-path', help='path to the aws credentials file', default=os.path.expanduser('~/.aws/credentials'))

args = parser.parse_args()

if args.profile is None:
    parser.error('Expecting --profile or profile set in environment AWS_PROFILE. e.g. "stage"')

config = configparser.ConfigParser()
config.read(args.credential_path)

if args.profile not in config.sections():
    parser.error('Invalid profile. Section not found in ~/.aws/credentails')

if args.arn is None:
    if 'aws_arn_mfa' not in config[args.profile]:
        sys.exit(0)
# parser.error('ARN is not provided. Specify via --arn')

    args.arn = config[args.profile]['aws_arn_mfa']
else:
    # Update the arn with user supplied one
    config[args.profile]['aws_arn_mfa'] = args.arn

# Generate the session token from the profile
result = subprocess.run(['aws', 'sts', 'get-session-token', '--profile', args.profile + '-default', '--serial-number', args.arn, '--token-code', args.token], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
if result.returncode != 0:
    parser.error(result.stderr.decode('utf-8').strip('\n'))

credentials = json.loads(result.stdout.decode('utf-8'))['Credentials']

config[args.profile]['aws_access_key_id'] = credentials['AccessKeyId']
config[args.profile]['aws_secret_access_key'] = credentials['SecretAccessKey']
config[args.profile]['aws_session_token'] = credentials['SessionToken']

# Save the changes back to the file
with open(args.credential_path, 'w') as configFile:
    config.write(configFile)

print('Saved {} credentials to {}'.format(args.profile, args.credential_path))
