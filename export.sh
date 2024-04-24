#!/bin/bash

# 環境変数の読み込み
source ./.env

# 昨日の日付を取得
YESTERDAY=$(date -v -1d '+%Y-%m-%d')

# リポジトリごとにIssueを取得する
for ((i = 0; i < ${#REPOSITORIES[@]}; i++)); do
  # 検索クエリ
  search_query="repo:${ORGANIZATION_NAME}/${REPOSITORIES[i]} is:issue is:closed sort:updated-desc closed:${YESTERDAY}"

  # Issueを取得
  gh api graphql -f query='
    query ($search_query: String!) {
      search(type: ISSUE, first: 100, query: $search_query) {
        nodes {
          ... on Issue {
            id
            title
            url
            repository {
              name
            }
            assignees(first: 10) {
              nodes {
                login
              }
            }
            createdAt
            closedAt
          }
        }
      }
    }' -f search_query="$search_query" >search_result.json
  
  # 取得したIssueを$ITEMSに格納する
  ITEMS=$(
    jq --arg project_id "$PROJECT_ID" '
      .data.search.nodes[]
    ' search_result.json |
      jq -cs .
  )
  # ITEMS配列の値をIssueのJSONファイルの配列の末尾に追加する
  CLOSED_ISSUES=$(jq -s '.[0] + .[1]' closed_issues.json <(echo "$ITEMS"))
  echo "$CLOSED_ISSUES" >closed_issues.json
done

# CSVに変換して出力
node jsonToCsv.mjs

# 生成したJSONファイルを削除
rm ./closed_issues.json
rm ./search_result.json