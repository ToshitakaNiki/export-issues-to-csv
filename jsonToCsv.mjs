import fs from 'fs'
import { readFile } from "fs/promises"
import { stringify } from "csv-stringify/sync"
import { format, intervalToDuration, formatDuration } from 'date-fns'
import ja from 'date-fns/locale/ja'

// GitHubから取得したJSONを読み込み
const issues = JSON.parse(await readFile('./closed_issues.json'))

// 配列をclosedAtの降順に並び替える
const sortedIssues = issues.sort((a, b) => {
  const dateA = new Date(a.closedAt)
  const dateB = new Date(b.closedAt)
  
  return dateB - dateA
})

// データを整形
const data = sortedIssues.map(issue => {
  // リードタイムを算出
  const readTime = formatDuration(intervalToDuration({
    start: issue.createdAt,
    end: issue.closedAt
  }), {
    locale: ja
  })
  
  return {
    id: issue.id,
    title: issue.title,
    url: issue.url,
    repository: issue.repository.name,
    assignees: issue.assignees.nodes.map(assignee => assignee.login).join('|'),
    createdAt:
    format(new Date(issue.createdAt), 'yyyy/MM/dd HH:mm:ss', { locale: ja }),
    closedAt: format(new Date(issue.closedAt), 'yyyy/MM/dd HH:mm:ss', { locale: ja }),
    readTime: readTime,
  }
})

// CSVフォーマットに変換
const csv = stringify(data, { header: true })

// CSVファイルを出力
fs.writeFileSync('readtime.csv', csv, { encoding: 'utf8' })