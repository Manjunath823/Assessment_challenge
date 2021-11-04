# Assessment_challenge

**Challenge #1**
* **Three tier AWS architecture**
 

![image](https://user-images.githubusercontent.com/71709261/140261302-2f87e544-7f8e-47d8-a71a-c8e9c7014e64.png)

**Improvement actions:**
* Architecture is designed for both production and recovery sites, could be implemented in a such a way that automatic load switching at the time of disaster using health checks or through manual change
* External load balancer can be leveraged for various other feature implementations so that application user traffic can be handled more effectively and in a secure way
* Possible options to consider for external ELB are SSL offloading, WAF implementation to guard against attaches, stickiness persistency, Global traffic manager to monitor the application health status etc.,
* Customized metrics can be defined for auto scaling launch templates based on the trend in user traffic
* DB hosts can be provisioned using in house services like RDS for better management and administration, replication mechanism can be defined and implemented for read replicas of DB instance
* Possible options can be considered for production site back up process. Volume gateways, EBS snapshots, S3 buckets can be used for the same
* Security groups can be configured with granular access controls, NACL configured for block listing/whitelisting few services or user IP address scope
 
**Points to be noted for current provisioning**
* Separate modules are configured for different services so as to make sure to have better visibility with infra provisioning and moreover defining such independent architecture is always recommended for complex architectures
* Clear text DB password interpolation is strictly not recommended, leveraging other security secret vault mechanism or key management systems would be few options to consider
* Key for SSH ssh_key.pub file can be edited with the public key that is already created or customized for each environment
 


