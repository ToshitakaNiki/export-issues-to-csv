# export-issues-to-csv
指定したリポジトリから、前日にClosedされたIssueをGitHub APIから取得し、CSVで出力します。  
ClosedになったIssueのリードタイムを計測する目的で作成したスクリプトです。

## セットアップ
### GitHubアカウント
GitHubのアカウントが必要です。

### GitHub CLI
GitHubのIssueは[GitHub CLI](https://docs.github.com/ja/github-cli/github-cli/about-github-cli)のAPIで取得します。  
GitHub CLIのインストールとAPIからデータを取得するための[アクセストークンの設定](https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)が必要です。

### Node.js
Node.jsの実行環境が必要です。

## CSVの出力手順

### 1. リポジトリををクローン
`git clone git@github.com:ToshitakaNiki/export-issues-to-csv.git`

### 2. `.env`の作成
`.env.example`から`.env`を複製し、値を書き換えます。 

| 環境変数名 | |
| :-- | :-- |
| ORGANIZATION_NAME | リポジトリの所有者名 |
| REPOSITORIES | リポジトリ名を`,`区切りで入力 |

### 3. GitHub CLIでログイン
`gh auth login`でGitHubにログインします。

> [!NOTE]
> ログイン方法の詳細は割愛します。[公式ページ](https://cli.github.com/manual/gh_auth_login)などを参考にしてください。

### 4. CSVファイルの出力
`./export.sh`でスクリプトを実行し、`readtime.csv`が出力されます。

> [!NOTE]
> スクリプトの実行権限がない場合は、`chmod -x ./export.sh`で実行権限を付与してください。

## アイデアの元
Classi株式会社様のブログ記事[「リードタイムを測るシェルスクリプトを作ってチームの振り返り会を活発にした話」](https://tech.classi.jp/entry/2024/02/28/124846)のアイデアを元に作成しました。
