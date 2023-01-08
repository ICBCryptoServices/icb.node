

# ![alt text](https://github.com/ICBCryptoServices/icb.node/blob/main/ICB-Logo.png?raw=true) icb.wallet
This is distribute service ICB NODE that user can deploy own ICB node on to own server


## System Requirements
  - [Install Git] (https://git-scm.com/downloads)
  - [Install Docker] (https://docs.docker.com/get-docker/)
  - [Install Docker Compose] (https://docs.docker.com/compose/install/)
  
  
## Get started
```ruby
git clone https://github.com/ICBCryptoServices/icb.node.git
```
```ruby
docker login docker-dev.icbcrypto.services
```
```
username : docker
password : docker
```

> Note: you should enter into folder icb.wallet


### Edit config env.config
  ```
export SERVER_NAME=[YOUR DOMAIN NAME]
```
> Note: [YOUR DOMAIN NAME] is domain address that you are registered for website!

## Configure SSL Certificates

> Note: you should enter into folder icb.wallet/nginx/ssl

### Generate SSL Private Key
  ```ruby
openssl req -newkey rsa:2048 -nodes -keyout ssl.key -out ssl.csr

```
### Edit SSL Key ssl.key in nginx/ssl/
  ```
-----BEGIN PRIVATE KEY-----
[YOUR PRIVATE KEY] 
-----END PRIVATE KEY-----
```
> Note: [YOUR PRIVATE KEY] is your ssl private key

### Edit SSL Cert ssl.crt in nginx/ssl/
  ```
-----BEGIN CERTIFICATE REQUEST-----
[YOUR CERTIFICATE REQUEST]
-----END CERTIFICATE REQUEST-----
-----BEGIN CERTIFICATE-----
[YOUR CERTIFICATE]
-----END CERTIFICATE-----
```
> Note: [YOUR CERTIFICATE REQUEST] is your ssl certificate request and [YOUR CERTIFICATE] is your ssl certificate



### Important for Linux -bash: ./manage.sh: Permission denied
> Note: ** if you are using linux you should access to manage.ssh **
  ```ruby
chmod u=rwx,g=r,o=r manage.sh

```


### Run a web node
open terminal and used command line
  ```ruby
cd icb.node
./manage.sh init
./manage.sh start
```

