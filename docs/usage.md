# Usage

## ObjectifiedHash

Gitlab returns `Gitlab::ObjectifiedHash` for items, which gives you object-like
access to the parsed JSON response

```rb
user = Gitlab.user
user.email #=> "john@example.com"
```

You can access the original hash by calling `to_h` or `to_hash` on the
`Gitlab::ObjectifiedHash` instance

```rb
user = Gitlab.user
hash = user.to_h
```

## Pagination

Use `page` (page number) and `per_page` (number of results per page) in the
options to paginate collections

```rb
Gitlab.projects(per_page: 5)
```
