# DynamoDB for Rails Application - A quick start

Follow the instructions in [this article for the step-by-step instruction](https://medium.com/@shettigarc/dynamodb-for-rails-developers-a-beginner-friendly-tutorial-669fe5a7b81a) on creating this Rails application and configuring AWS DynamoDB locally. 

If you've read that and understand the steps, then here are the instructions on getting this app up and running. I use Docker & Docker Compose with [DevContainer](https://www.devteds.com/devcontainers-for-developers-multi-container-local-dev-setup/) and I primarily use VSCode. If you don't use VSCode, you can still get this running locally with docker & docker-compose.


## Setup Docker Environment: `DevContainer + Docker Compose`


```
cp .devcontainer/devcontainer-example.json .devcontainer/devcontainer.json 
# Edit the devcontainer.json for path for user home directory containing .ssh or .aws. Or you can remove the mounts section completely

cp docker-compose-example.yml docker-compose.yml
# Edit to change AWS credential variables
# Uncomment "command: tail -f /dev/null"
```

VSCode (command pallete): `DevContainers > Rebuild and Reopen in Container`

Inside the container environment,

Bundle install:

```
bundle
```

Let's create table and load some test data into the local DynamoDB:

```
rails aws_record:migrate
rails runner db/seeds.rb
```

Verify the data on Rails console:

```
rails c
> Product.scan
```

Run rails server:

```
rails s -b 0.0.0.0
```

cURL or use the browser to hit: `http://localhost:<HOST-PORT>/products`


```
curl -s http://localhost:3400/products | jq
curl -v http://localhost:3400/products
```


## Setup Docker Compose Environment (No DevContainer or VSCode)

```
cp docker-compose-example.yml docker-compose.yml
# Edit to change AWS credential variables; update host ports for api & dynamo

docker-compose build
```

Run migratin, load some test data and verify using Rails Console:

```
docker-compose run --rm api bash
> bundle
> rails aws_record:migrate
> rails runner db/seeds.rb
> rails c
  > Product.scan
  > exit
> exit   
```

Run the app & verify

```
docker-compose up
```

cURL or use the browser to hit: `http://localhost:<HOST-PORT>/products`


```
curl -s http://localhost:3400/products | jq
curl -v http://localhost:3400/products
```

