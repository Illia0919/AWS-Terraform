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
5. Use Terraform as infraesctructure as code tool
