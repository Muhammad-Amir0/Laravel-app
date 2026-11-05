## Assignment Questions!

### Q1. Why should the MySQL application user only be allowed to connect from the application server's IP address?

*Answer:

The MySQL application user should only be allowed to connect from the application server's private IP address because of the principle of least privilege.

In our project, the application server connects to the database server using its private IP address. Restricting database access to this IP prevents unauthorized machines from connecting with the application user's credentials and improves database security.

### Q2. What happens if an application update fails, and how can we prevent downtime on the live website?

*Answer:

If an update fails after being deployed to the live server, it can cause application errors or make the website unavailable.

To reduce this risk, we should test updates before deployment, use a staging environment, take backups, and perform health checks after deployment. We should also maintain a rollback plan so that we can restore the previous working version if the update fails.

### Q3. Why are database backups stored on the application server instead of only on the database server? What is the risk?

*Answer:

Storing database backups on the application server keeps a separate copy of the database backup outside the database server.

If the database server fails, the backup on the application server may still be available for recovery.

However, if the application server also fails, locally stored backups could be lost. Therefore, an additional off-site backup location, such as Amazon S3, is recommended.

### Q4. How frequently should database backups run, and how much data could we lose if a failure occurs?

*Answer:

Our database backup is scheduled to run daily at 2:00 AM using cron.

With successful daily backups, the potential data loss could be up to almost 24 hours of database changes if a failure happens just before the next backup.

For applications with frequent transactions, more frequent backups may be necessary.

### Q5. Why is it important to test database backups by restoring them?

*Answer:

A backup is only useful if it can be restored successfully.

Restore testing verifies that the backup file is not corrupted, the database can be recovered, and the application can access the restored data.

We should perform restore tests regularly, preferably monthly, and after making major changes to the backup process.

### Q6. Explain how DNS connects a user's browser to our application server.

*Answer:

DNS (Domain Name System) translates a domain name into an IP address.

When a user enters our website's domain name into a browser, the browser requests the IP address from a DNS resolver. The DNS resolver looks up the domain's DNS record, such as an A record, and returns the application server's public IP address.

The browser then connects to the server, where Nginx receives the request and routes it to the appropriate website or application.

