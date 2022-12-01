import boto3

ec2_client = boto3.client("ec2")
ec2 = boto3.resource("ec2")

my_ami = ec2_client.describe_images(Owners=['self'])

for ami in my_ami['Images']:
  ami_id = ami['ImageId']
  ec2_client.deregister_image(ImageId=ami_id)
  print(f"AMI Resource deleted : {ami_id}")

snapshots = ec2.snapshots.filter(OwnerIds=['self'])

for snapshot in snapshots:
  snapshot.delete()
  print(f"Snapshot deleted")

for vol in ec2_client.describe_volumes()['Volumes']:
  if vol['State'] == 'available':
    if 'Tags' in vol:
      if {"Key" : "Name", "Value" : "instance_provisioned"} in vol['Tags']:
        ec2_client.delete_volume(VolumeId = vol['VolumeId'])
        print(f"Volume id deleted : {vol['VolumeId']}")