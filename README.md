# Infrastructure deployment exercise

Using Terraform, automate the build of the following application in AWS. For the purposes of this challenge, use any Linux based AMI id for the two EC2 instances and simply show how they would be provisioned with the connection details for the RDS cluster.

![diagram](./images/diagram.png)

There are a lot of additional resources to create even in this simple setup, you can use the code we have made available that will create some structure and deploy the networking environment to make it possible to plan/apply the full deployment. Feel free to use and/or modify as much or as little of it as you like.

Document any assumptions or additions you make in the README for the code repository. You may also want to consider and make some notes on:

How would a future application obtain the load balancer’s DNS name if it wanted to use this service?

What aspects need to be considered to make the code work in a CD pipeline (how does it successfully and safely get into production)?

# Infrastructure review

## ALB
Consists in a simple listener rule on port 80 forwarding the request to the target group.

## ASG
The Autoscaling group will be attached to the load balancer allowing the ec2 instances connecting direct with the ALB, from there those instances will be automatically attached to the target group. 
## IAM
Allow users to connect on the instance via the AWS console, the SSMInstanceProfile policy allows connectivity from "Session Manager".

## How to test the ALB to check whether works?
After deployed, grab the ALB DNS name and paste on the URL as the port 80 will be open, a small Hello World message shoudl display :) 

## How test connectivity from the EC2 instances to the RDS instance?
- Login via the AWS console by selecting the ec2 instance and click in `Connect`
- Open `Session Manager`
- Run telnet command `telnet <db_endpoint> 3306`
## Further improvements
- Having a DNS (Route53 alias) created in front of the ALB inside a hosted zone to have a proper name of the service.
- Instead of having applications listening on port 80 (HTTP), would be safer create a ACM (AWS Certificate Manager) and create a listener rules redirect the port 80 to 443.
- IAM roles/policies would be a better restrictions of certain resources.
- CICD integration could be integrated on GitHub Actions, GitLabCI, Jenkins, Atlantis... 
