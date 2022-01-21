# Terraform Evaluation

1. Create an API to persist and retrieve contacts.

2. Contact structure

```
{
  "contact_id": hash,
  "name": string,
  "dob": string,
  "phones": array of string,
  "emails": array of string,
  "primary_phone": string,
  "primary_email": string,
}
```

3. Use REST API or GraphQL
4. Use DynamoDB to persist data
5. Use Terraform as infrastructure as code tool


# API Documentation

## Create Contact
Create a contact 

**URL** : `/api/contacts`

**Method** : `POST`

```json
{
  "name": "Moises",
  "dob": "88-June-10",
  "phones": ["5547992571281"],
  "emails": ["moises@primelab.io"],
  "primary_phone": "5547992571281",
  "primary_email": "moises@primelab.io"
}
```

## Success Response

**Condition** : If everything is OK, contact is created.

**Code** : `200 OK`

**Content example**

```json
{
  "contact_id": "51e91cc1-9e41-473b-889c-09a3e98cbd83",
  "name": "Moises",
  "dob": "88-June-10",
  "emails": [
    "moises@primelab.io"
  ],
  "phones": [
    "5547992571281"
  ],
  "primary_email": "moises@primelab.io",
  "primary_phone": "5547992571281"
}
```


## Retrieve Contact

Create a contact

**URL** : `/api/contacts/:id`

**URL Parameters** : `id=[integer]` where `id` is the ID of the Contact on the
server.

**Method** : `GET`

## Success Response

**Condition** : If everything is OK.

**Code** : `200 OK`

**Content example**

```json
{
  "contact_id": "51e91cc1-9e41-473b-889c-09a3e98cbd83",
  "name": "Moises",
  "dob": "88-June-10",
  "emails": [
    "moises@primelab.io"
  ],
  "phones": [
    "5547992571281"
  ],
  "primary_email": "moises@primelab.io",
  "primary_phone": "5547992571281"
}
```

## Error Responses

**Condition** : If Contact does not exist with `id` of provided `id` parameter.

**Code** : `404 NOT FOUND`

**Content** : 
```json
{
  "code": "Not Found",
  "message": "Contact Not Found"
}
```

