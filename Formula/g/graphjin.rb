class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.1.4.tar.gz"
  sha256 "bf3a9b49a1b947bc547f484d72a112894a7f2a66f2c2205aa81046c1e1882151"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8acfd60766cd8332dd901d8d6eea5a864f7de2e5ffb6b852809e0be0f5d92000"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8acfd60766cd8332dd901d8d6eea5a864f7de2e5ffb6b852809e0be0f5d92000"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8acfd60766cd8332dd901d8d6eea5a864f7de2e5ffb6b852809e0be0f5d92000"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79de24e84911ff2593f46348917d7c179239d55d472b22d494145e17e0cb66f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb996d02eed8a5060ec371283ee497de3d3b9bde3058545000970e8e3c21fa43"
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

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
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
index 19dfd91..3b98377 100644
--- a/auth/go.mod
+++ b/auth/go.mod
@@ -3,7 +3,7 @@ module github.com/dosco/graphjin/auth/v3
 go 1.24.0
 
 require (
-	github.com/dosco/graphjin/core/v3 v-00010101000000-000000000000
+	github.com/dosco/graphjin/core/v3 v3.1.4
 	github.com/golang-jwt/jwt v3.2.2+incompatible
 	github.com/gorilla/websocket v1.5.3
 	github.com/lestrrat-go/jwx v1.2.31
diff --git a/cmd/go.mod b/cmd/go.mod
index 1170212..80e7dc5 100644
--- a/cmd/go.mod
+++ b/cmd/go.mod
@@ -5,8 +5,8 @@ go 1.24.0
 require (
 	github.com/brianvoe/gofakeit/v6 v6.28.0
 	github.com/dop251/goja v0.0.0-20250630131328-58d95d85e994
-	github.com/dosco/graphjin/core/v3 v-00010101000000-000000000000
-	github.com/dosco/graphjin/serv/v3 v-00010101000000-000000000000
+	github.com/dosco/graphjin/core/v3 v3.1.4
+	github.com/dosco/graphjin/serv/v3 v3.1.4
 	github.com/gosimple/slug v1.15.0
 	github.com/jackc/pgx/v5 v5.7.6
 	github.com/jvatic/goja-babel v0.0.0-20250906111304-06c40d6b931b
@@ -27,8 +27,8 @@ require (
 	filippo.io/edwards25519 v1.1.0 // indirect
 	github.com/decred/dcrd/dcrec/secp256k1/v4 v4.4.0 // indirect
 	github.com/dlclark/regexp2 v1.11.5 // indirect
-	github.com/dosco/graphjin/auth/v3 v-00010101000000-000000000000 // indirect
-	github.com/dosco/graphjin/plugin/otel/v3 v-00010101000000-000000000000 // indirect
+	github.com/dosco/graphjin/auth/v3 v3.1.4 // indirect
+	github.com/dosco/graphjin/plugin/otel/v3 v3.1.4 // indirect
 	github.com/felixge/httpsnoop v1.0.4 // indirect
 	github.com/fsnotify/fsnotify v1.9.0 // indirect
 	github.com/go-chi/chi/v5 v5.2.3 // indirect
diff --git a/conf/go.mod b/conf/go.mod
index 3d13602..96110a7 100644
--- a/conf/go.mod
+++ b/conf/go.mod
@@ -3,7 +3,7 @@ module github.com/dosco/graphjin/conf/v3
 go 1.24.0
 
 require (
-	github.com/dosco/graphjin/core/v3 v-00010101000000-000000000000
+	github.com/dosco/graphjin/core/v3 v3.1.4
 	gopkg.in/yaml.v3 v3.0.1
 )
 
diff --git a/plugin/otel/go.mod b/plugin/otel/go.mod
index beb9eda..23287f9 100644
--- a/plugin/otel/go.mod
+++ b/plugin/otel/go.mod
@@ -3,7 +3,7 @@ module github.com/dosco/graphjin/plugin/otel/v3
 go 1.24.0
 
 require (
-	github.com/dosco/graphjin/core/v3 v-00010101000000-000000000000
+	github.com/dosco/graphjin/core/v3 v3.1.4
 	go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp v0.63.0
 	go.opentelemetry.io/otel v1.38.0
 	go.opentelemetry.io/otel/trace v1.38.0
diff --git a/serv/go.mod b/serv/go.mod
index 4cbb328..609313f 100644
--- a/serv/go.mod
+++ b/serv/go.mod
@@ -3,9 +3,9 @@ module github.com/dosco/graphjin/serv/v3
 go 1.24.0
 
 require (
-	github.com/dosco/graphjin/auth/v3 v-00010101000000-000000000000
-	github.com/dosco/graphjin/core/v3 v-00010101000000-000000000000
-	github.com/dosco/graphjin/plugin/otel/v3 v-00010101000000-000000000000
+	github.com/dosco/graphjin/auth/v3 v3.1.4
+	github.com/dosco/graphjin/core/v3 v3.1.4
+	github.com/dosco/graphjin/plugin/otel/v3 v3.1.4
 	github.com/fsnotify/fsnotify v1.9.0
 	github.com/go-http-utils/headers v0.0.0-20181008091004-fed159eddc2a
 	github.com/go-pkgz/expirable-cache v1.0.0
diff --git a/tests/go.mod b/tests/go.mod
index 51b5719..ed67332 100644
--- a/tests/go.mod
+++ b/tests/go.mod
@@ -3,8 +3,8 @@ module github.com/dosco/graphjin/tests/v3
 go 1.24.0
 
 require (
-	github.com/dosco/graphjin/conf/v3 v-00010101000000-000000000000
-	github.com/dosco/graphjin/core/v3 v-00010101000000-000000000000
+	github.com/dosco/graphjin/conf/v3 v3.1.4
+	github.com/dosco/graphjin/core/v3 v3.1.4
 	github.com/go-sql-driver/mysql v1.9.3
 	github.com/lib/pq v1.10.9
 	github.com/stretchr/testify v1.11.1
diff --git a/wasm/go.mod b/wasm/go.mod
index 36f9bc2..51d6904 100644
--- a/wasm/go.mod
+++ b/wasm/go.mod
@@ -3,8 +3,8 @@ module github.com/dosco/graphjin/wasm/v3
 go 1.24.0
 
 require (
-	github.com/dosco/graphjin/conf/v3 v-00010101000000-000000000000
-	github.com/dosco/graphjin/core/v3 v-00010101000000-000000000000
+	github.com/dosco/graphjin/conf/v3 v3.1.4
+	github.com/dosco/graphjin/core/v3 v3.1.4
 )
 
 replace (
