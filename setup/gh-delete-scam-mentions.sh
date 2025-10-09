#!/bin/bash

# Delete scam mentions from GitHub issues

gh api notifications | jq '.[] | { id, title: .subject.title, repo: .repository.full_name }'

# You will get notification id from JSON. Replace $THREAD_ID with the id
gh api --method DELETE notifications/threads/$THREAD_ID
