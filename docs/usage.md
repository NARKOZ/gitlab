# Usage

## ObjectifiedHash

Gitlab returns `Gitlab::ObjectifiedHash` for items which gives you object-like
access to parsed JSON response

```rb
user = Gitlab.user
user.email #=> "john@example.com"
```

You can access the original hash by running `to_h` or `to_hash` on
`Gitlab::ObjectifiedHash` instance

```rb
user = Gitlab.user
hash = user.to_h
```

## Pagination

Use `page` (page number) and `per_page` (number of results per page) in options to
paginate collections

```rb
Gitlab.projects(per_page: 5)
```
