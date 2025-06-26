Remove block on nytimes.com
```
||meter-svc.nytimes.com^
nytimes.com##+js(cookie-remover, /^/)
nytimes.com##+js(json-prune, data.user.messageSelection)
nytimes.com##+js(json-prune-fetch-response, data.user.messageSelection)
nytimes.com##+js(json-prune-xhr-response, data.user.messageSelection)
nytimes.com##+js(trusted-replace-fetch-response, messageSelection, m, samizdat-graphql)
```