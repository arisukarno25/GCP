### how to run 
- terraform init
- terraform plan -out=tfplan
- terraform apply tfplan

### Cloud SQL Proxy
#### The Cloud SQL Proxy provides secure access to your Cloud SQL

#### Accessing your Cloud SQL instance using the Cloud SQL Proxy offers these advantages: 
- Secure connections: The proxy automatically encrypts traffic to and from the database using TLS 1.2 with a 128-bit AES cipher; SSL certificates are used to verify client and server identities.
- Easier connection management: The proxy handles authentication with Cloud SQL, removing the need to provide static IP addresses.

#### Installing the Cloud SQL Proxy
Download the proxy:

- wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
- chmod +x cloud_sql_proxy

#### You can install the proxy anywhere in your environment. The location of the proxy binaries does not impact where it listens for data from your application

#### Test connection to the database
#### Start by running the Cloud SQL proxy for the Cloud SQL instance:

- export GOOGLE_PROJECT=$(gcloud config get-value project)
- MYSQL_DB_NAME=$(terraform output -json | jq -r '.instance_name.value')
- MYSQL_CONN_NAME="${GOOGLE_PROJECT}:us-central1:${MYSQL_DB_NAME}"
- ./cloud_sql_proxy -instances=${MYSQL_CONN_NAME}=tcp:3306

##### Now you'll start another Cloud Shell tab by clicking on plus (+) icon. You'll use this shell to connect to the Cloud SQL proxy.

##### Navigate to sql-with-terraform directory:

Get the generated password for MYSQL:
- echo MYSQL_PASSWORD=$(terraform output -json | jq -r '.generated_user_password.value')
##### Test the MySQL connection:
- mysql -udefault -p --host 127.0.0.1 default
##### When prompted, enter the value of MYSQL_PASSWORD, found in the output above, and press Enter.