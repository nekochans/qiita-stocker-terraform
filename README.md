# qiita-stocker-terraform

# 事前準備

## AWSクレデンシャルの設定

自身の利用しているMacOS PC上で `brew install awscli` を実行します。

`aws configure --profile qiita-stocker-dev` を実行します。

対話式のインターフェースに以下を入力します。

```
AWS Access Key ID [None]: `アクセスキーIDを入力`
AWS Secret Access Key [None]: `シークレットアクセスキーを入力`
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

同じく `aws configure --profile qiita-stocker-dev` を実行します。

先程と同じように対話式のインターフェースに従い必要な情報を入力します。

`~/.aws/credentials` に下記のように設定されていればOKです。

```
[qiita-stocker-dev]
aws_access_key_id = 開発・ステージング用アクセスキーID
aws_secret_access_key = 開発・ステージング用シークレットアクセスキー
[qiita-stocker-prod]
aws_access_key_id = 本番用アクセスキーID
aws_secret_access_key = 本番用シークレットアクセスキー
```

`brew install awscli` を実行しない場合でもともかく `~/.aws/credentials` が上記の状態になっていればOKです。

## コーディング規約

以下の命名規則に従って命名します。

| 項目名         | 命名規則       |
|----------------|----------------|
| ファイル名     | ケバブケース   |
| ディレクトリ名 | ケバブケース   |
| リソースID     | スネークケース |
| リソース名     | ケバブケース   |
| 変数名         | スネークケース |

リソースIDというのは `resource` や `data` 等のTerraformの予約語に付けられる名前です。

```hcl
resource "aws_security_group_rule" "ssh_from_all_to_bastion" {
}
```

リソース名はそのリソースの中で一意になっている必要がある値です。

下記の例だと `key_name` がそれに該当します。

```hcl
resource "aws_key_pair" "ssh_key_pair" {
  public_key = "${file(var.ssh_public_key_path)}"
  key_name   = "${terraform.workspace}-ssh-key"
}
```

他にもタグ名を良く付ける事がありますが、それもこちらのルールの通りケバブケースで命名します。

```
  tags {
    Name = "${lookup(var.bastion, "${terraform.env}.name", var.bastion["default.name"])}-1a"
  }
```

このようなややこしい規則になっている理由ですが、RDSCluster等、一部のリソース名で `_` が禁止文字に設定されている為です。

他にもインデント等細かいルールがありますが、こちらに関しては `terraform fmt` を実行すれば自動整形されるのでこれを利用すれば良いでしょう。

`terraform fmt` は必ずプロジェクトルートで実行を行ってください。

そうしないと全ての `.tf` ファイルに修正が適応されません。
