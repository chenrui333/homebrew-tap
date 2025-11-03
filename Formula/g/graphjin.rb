class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "476e370b9ab1133c6a08fa63ce8e2f71a8ed16e7be2c858e389012f1ee940616"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "715a930b6dd6396ea52eea81116b5ad8e90d4ab37301c1da29d836cb788d7486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "715a930b6dd6396ea52eea81116b5ad8e90d4ab37301c1da29d836cb788d7486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "715a930b6dd6396ea52eea81116b5ad8e90d4ab37301c1da29d836cb788d7486"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "305f3e891c9566f26fd344bb7a5e1c4bbd6f2b1665213d84b132e52014a01b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067d495ab3e60808164182f7e7dc7fa36b83e0447ae2ad0eb1405c0ca803374c"
  end

  depends_on "go" => :build

  # Fix go.mod files with invalid version specs (bare "v" without version)
  patch :DATA

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/config/dev.yml").read
  end
end

__END__
diff --git a/auth/go.mod b/auth/go.mod
index 3e97801..5b5e93f 100644
--- a/auth/go.mod
+++ b/auth/go.mod
@@ -5,7 +5,7 @@ go 1.23.0
 require (
 	github.com/adjust/gorails v0.0.0-20171013043634-2786ed0c03d3
 	github.com/bradfitz/gomemcache v0.0.0-20230905024940-24af94b03874
-	github.com/dosco/graphjin/core/v3 v
+	github.com/dosco/graphjin/core/v3 v3.1.3
 	github.com/golang-jwt/jwt v3.2.2+incompatible
 	github.com/gomodule/redigo v1.9.2
 	github.com/gorilla/websocket v1.5.3
diff --git a/cmd/go.mod b/cmd/go.mod
index b544f1c..97728f8 100644
--- a/cmd/go.mod
+++ b/cmd/go.mod
@@ -7,8 +7,8 @@ toolchain go1.23.1
 require (
 	github.com/brianvoe/gofakeit/v6 v6.28.0
 	github.com/dop251/goja v0.0.0-20240828124009-016eb7256539
-	github.com/dosco/graphjin/core/v3 v
-	github.com/dosco/graphjin/serv/v3 v
+	github.com/dosco/graphjin/core/v3 v3.1.3
+	github.com/dosco/graphjin/serv/v3 v3.1.3
 	github.com/gosimple/slug v1.14.0
 	github.com/jackc/pgx/v5 v5.6.0
 	github.com/jvatic/goja-babel v0.0.0-20240829121804-52a2d5a94eb5
@@ -45,8 +45,8 @@ require (
 	github.com/decred/dcrd/dcrec/secp256k1/v4 v4.3.0 // indirect
 	github.com/dimchansky/utfbom v1.1.1 // indirect
 	github.com/dlclark/regexp2 v1.11.4 // indirect
-	github.com/dosco/graphjin/auth/v3 v // indirect
-	github.com/dosco/graphjin/plugin/otel/v3 v // indirect
+	github.com/dosco/graphjin/auth/v3 v3.1.3 // indirect
+	github.com/dosco/graphjin/plugin/otel/v3 v3.1.3 // indirect
 	github.com/fatih/color v1.16.0 // indirect
 	github.com/felixge/httpsnoop v1.0.4 // indirect
 	github.com/fsnotify/fsnotify v1.7.0 // indirect
diff --git a/conf/go.mod b/conf/go.mod
index 513264e..2ba508f 100644
--- a/conf/go.mod
+++ b/conf/go.mod
@@ -3,7 +3,7 @@ module github.com/dosco/graphjin/conf/v3
 go 1.18

 require (
-	github.com/dosco/graphjin/core/v3 v
+	github.com/dosco/graphjin/core/v3 v3.1.3
 	gopkg.in/yaml.v3 v3.0.1
 )

diff --git a/plugin/otel/go.mod b/plugin/otel/go.mod
index 0c0580f..44bfb30 100644
--- a/plugin/otel/go.mod
+++ b/plugin/otel/go.mod
@@ -5,7 +5,7 @@ go 1.21
 toolchain go1.23.1

 require (
-	github.com/dosco/graphjin/core/v3 v
+	github.com/dosco/graphjin/core/v3 v3.1.3
 	go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp v0.42.0
 	go.opentelemetry.io/otel v1.29.0
 	go.opentelemetry.io/otel/trace v1.29.0
diff --git a/serv/go.mod b/serv/go.mod
index 15e04b5..8fb5688 100644
--- a/serv/go.mod
+++ b/serv/go.mod
@@ -5,9 +5,9 @@ go 1.23.0
 toolchain go1.23.5

 require (
-	github.com/dosco/graphjin/auth/v3 v
-	github.com/dosco/graphjin/core/v3 v
-	github.com/dosco/graphjin/plugin/otel/v3 v
+	github.com/dosco/graphjin/auth/v3 v3.1.3
+	github.com/dosco/graphjin/core/v3 v3.1.3
+	github.com/dosco/graphjin/plugin/otel/v3 v3.1.3
 	github.com/fsnotify/fsnotify v1.9.0
 	github.com/go-http-utils/headers v0.0.0-20181008091004-fed159eddc2a
 	github.com/go-pkgz/expirable-cache v1.0.0
diff --git a/tests/go.mod b/tests/go.mod
index 4450474..97aa5dd 100644
--- a/tests/go.mod
+++ b/tests/go.mod
@@ -5,8 +5,8 @@ go 1.21
 toolchain go1.23.1

 require (
-	github.com/dosco/graphjin/conf/v3 v
-	github.com/dosco/graphjin/core/v3 v
+	github.com/dosco/graphjin/conf/v3 v3.1.3
+	github.com/dosco/graphjin/core/v3 v3.1.3
 	github.com/orlangure/gnomock v0.30.0
 	github.com/stretchr/testify v1.9.0
 	golang.org/x/sync v0.8.0
diff --git a/wasm/go.mod b/wasm/go.mod
index caee9bd..b925ab2 100644
--- a/wasm/go.mod
+++ b/wasm/go.mod
@@ -3,8 +3,8 @@ module github.com/dosco/graphjin/wasm/v3
 go 1.18

 require (
-	github.com/dosco/graphjin/conf/v3 v
-	github.com/dosco/graphjin/core/v3 v
+	github.com/dosco/graphjin/conf/v3 v3.1.3
+	github.com/dosco/graphjin/core/v3 v3.1.3
 )

 require (
