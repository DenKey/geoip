# INSTALLATION

1) Sure that you have installed `docker` and `docker-compose` command tools
2) 'cd' to project directory in console
3) run `docker-compose build`
4) run `docker-compose up`
5) Open [http://localhost:3000](http://localhost:3000)

# API

- Database already seeded with some sort of data. Look at `seeds.rb`.
- Main endpoint 'http://localhost:3000/api/v1/ip_addresses'

### POST /lookup - will find record in our DB by IP or Domain 
```
POST http://localhost:3000/api/v1/ip_addresses/lookup
Content-Type: application/json

{
  "data": {
    "resource": "google.com"
  }
}
```

```
{
  "data": [
    {
      "type": "ip_address",
      "id": 1,
      "attributes": {
        "ip_address": "172.253.63.113",
        "longitude": -122.07540893554688,
        "latitude": 37.419158935546875
      }
    }
  ]
}
```

### POST /delete - find record by IP or Domain in DB and destroy it 

```
POST http://localhost:3000/api/v1/ip_addresses/delete
Content-Type: application/json

{
  "data": {
    "resource": "http://www.cocacola.com"
  }
}
```

```
ok
```

### POST / - creates new record in our db is it's not exists. Accept IP or Domain.


```
POST http://localhost:3000/api/v1/ip_addresses
Content-Type: application/json

{
  "data": {
    "resource": "https://www.perl.org/"
  }
}
```

```
{
  "data": [
    {
      "type": "ip_address",
      "id": 11,
      "attributes": {
        "ip_address": "139.178.67.96",
        "longitude": -74.19452667236328,
        "latitude": 40.738731384277344
      }
    }
  ]
}
```