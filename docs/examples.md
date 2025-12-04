# Examples

## Get private token

Authorize and get private token of a user

```rb
user = Gitlab.session('email', 'password')
user.private_token #=> "qEsq1pt6HJPaNciie3MG"
```

## Mass create projects

Bulk create projects and repositories

```rb
# See: https://narkoz.github.io/gitlab/configuration
client = Gitlab.client(endpoint: endpoint, private_token: private_token)

project_names = %w[project1 project2 project007]

project_names.each do |name|
  project = client.create_project name
  puts "#{name} created on #{project.web_url}"
end
```

## Handling errors

The client raises errors inherited from `Gitlab::Error::Error`

```rb
begin
  client.create_project 'example'
rescue Gitlab::Error::Error => error
  puts error
end
```
