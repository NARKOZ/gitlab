# Configuration

You need to set an API endpoint URL before usage

```sh
Gitlab.endpoint = 'https://example.net/api/v4'
```

Set the GitLab user's private token (not required for `session`)

```sh
Gitlab.private_token = 'qEsq1pt6HJPaNciie3MG'
```

## Sudo

Optionally, you can set the `sudo` parameter to perform API calls as another user

```sh
Gitlab.sudo = 'other_user'
```

To disable it:

```sh
Gitlab.sudo = nil
```

## Clients

You can set different configuration values for each client

```sh
client1 = Gitlab.client(endpoint: 'https://api1.example.com', private_token: 'user-001')
client2 = Gitlab.client(endpoint: 'https://api2.example.com', private_token: 'user-002')
```

## Environment variables

Gitlab uses `GITLAB_API_ENDPOINT` and `GITLAB_API_PRIVATE_TOKEN` environment
variables by default.

## Ruby on Rails

Create the file `config/initializers/gitlab.rb` and insert the following code
into it. Edit where necessary.

```rb
Gitlab.configure do |config|
  config.endpoint       = 'https://example.net/api/v4'
  config.private_token  = ''
  config.user_agent     = 'Custom User Agent'
end
```
