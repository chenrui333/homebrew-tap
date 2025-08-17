class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "4e13865b41b604dcf589e31a9363506fd9f8ddb9e823c66c67abff8e71a2d10a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c247703ba8789ebfd0c3bfb2d791be395ea46816496c91bd06e6d7d014a8a7ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2ec58c000e5a9112e3808503b7008c8e4ea8ff96f978282935cbbd0ee3d2648"
    sha256 cellar: :any_skip_relocation, ventura:       "a31296aadda5d934fee9e18d55c32111c8adcca658b266d691148b1890eff2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "096c1e14abcc3ff4f58cbc16c615ce885741d9f3717354323e0abf97b2f64b72"
  end

  depends_on "go" => :build

  patch :DATA

  def install
    # Prevent init() from overwriting ldflags version
    inreplace "pkg/version/version.go",
              "if len(bi.Main.Version) > 0",
              "if len(bi.Main.Version) > 0 && Version == \"(dev)\""

    ldflags = "-s -w -X github.com/sjzar/chatlog/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chatlog version")
    assert_match "failed to get key", shell_output("#{bin}/chatlog key 2>&1")
  end
end

__END__
diff --git a/go.mod b/go.mod
index e196dc9..1e8400c 100644
--- a/go.mod
+++ b/go.mod
@@ -11,14 +11,14 @@ require (
 	github.com/pierrec/lz4/v4 v4.1.22
 	github.com/rivo/tview v0.0.0-20250330220935-949945f8d922
 	github.com/rs/zerolog v1.34.0
-	github.com/shirou/gopsutil/v4 v4.25.3
+	github.com/shirou/gopsutil/v4 v4.25.7
 	github.com/sirupsen/logrus v1.9.3
 	github.com/sjzar/go-lame v0.0.8
 	github.com/sjzar/go-silk v0.0.1
 	github.com/spf13/cobra v1.9.1
 	github.com/spf13/viper v1.20.1
 	golang.org/x/crypto v0.37.0
-	golang.org/x/sys v0.32.0
+	golang.org/x/sys v0.34.0
 	google.golang.org/protobuf v1.36.6
 	howett.net/plist v1.0.1
 )
@@ -27,7 +27,7 @@ require (
 	github.com/bytedance/sonic v1.13.2 // indirect
 	github.com/bytedance/sonic/loader v0.2.4 // indirect
 	github.com/cloudwego/base64x v0.1.5 // indirect
-	github.com/ebitengine/purego v0.8.2 // indirect
+	github.com/ebitengine/purego v0.8.4 // indirect
 	github.com/fsnotify/fsnotify v1.9.0 // indirect
 	github.com/gabriel-vasile/mimetype v1.4.8 // indirect
 	github.com/gdamore/encoding v1.0.1 // indirect
diff --git a/go.sum b/go.sum
index f6135b0..3a5d34d 100644
--- a/go.sum
+++ b/go.sum
@@ -13,6 +13,8 @@ github.com/davecgh/go-spew v1.1.1 h1:vj9j/u1bqnvCEfJOwUhtlOARqs3+rkHYY13jYWTU97c
 github.com/davecgh/go-spew v1.1.1/go.mod h1:J7Y8YcW2NihsgmVo/mv3lAwl/skON4iLHjSsI+c5H38=
 github.com/ebitengine/purego v0.8.2 h1:jPPGWs2sZ1UgOSgD2bClL0MJIqu58nOmIcBuXr62z1I=
 github.com/ebitengine/purego v0.8.2/go.mod h1:iIjxzd6CiRiOG0UyXP+V1+jWqUXVjPKLAI0mRfJZTmQ=
+github.com/ebitengine/purego v0.8.4 h1:CF7LEKg5FFOsASUj0+QwaXf8Ht6TlFxg09+S9wz0omw=
+github.com/ebitengine/purego v0.8.4/go.mod h1:iIjxzd6CiRiOG0UyXP+V1+jWqUXVjPKLAI0mRfJZTmQ=
 github.com/frankban/quicktest v1.14.6 h1:7Xjx+VpznH+oBnejlPUj8oUpdxnVs4f8XU8WnHkI4W8=
 github.com/frankban/quicktest v1.14.6/go.mod h1:4ptaffx2x8+WTWXmUCuVU6aPUX1/Mz7zb5vbUoiM6w0=
 github.com/fsnotify/fsnotify v1.9.0 h1:2Ml+OJNzbYCTzsxtv8vKSFD9PbJjmhYF14k/jKC7S9k=
@@ -111,6 +113,8 @@ github.com/sagikazarmark/locafero v0.9.0 h1:GbgQGNtTrEmddYDSAH9QLRyfAHY12md+8YFT
 github.com/sagikazarmark/locafero v0.9.0/go.mod h1:UBUyz37V+EdMS3hDF3QWIiVr/2dPrx49OMO0Bn0hJqk=
 github.com/shirou/gopsutil/v4 v4.25.3 h1:SeA68lsu8gLggyMbmCn8cmp97V1TI9ld9sVzAUcKcKE=
 github.com/shirou/gopsutil/v4 v4.25.3/go.mod h1:xbuxyoZj+UsgnZrENu3lQivsngRR5BdjbJwf2fv4szA=
+github.com/shirou/gopsutil/v4 v4.25.7 h1:bNb2JuqKuAu3tRlPv5piSmBZyMfecwQ+t/ILq+1JqVM=
+github.com/shirou/gopsutil/v4 v4.25.7/go.mod h1:XV/egmwJtd3ZQjBpJVY5kndsiOO4IRqy9TQnmm6VP7U=
 github.com/sirupsen/logrus v1.9.3 h1:dueUQJ1C2q9oE3F7wvmSGAaVtTmUizReu6fjN8uqzbQ=
 github.com/sirupsen/logrus v1.9.3/go.mod h1:naHLuLoDiP4jHNo9R0sCBMtWGeIprob74mVsIT4qYEQ=
 github.com/sjzar/go-lame v0.0.8 h1:AS9l32R6foMiMEXWfUY8i79WIMfDoBC2QqQ9s5yziIk=
@@ -204,6 +208,8 @@ golang.org/x/sys v0.20.0/go.mod h1:/VUhepiaJMQUp4+oa/7Zr1D23ma6VTLIYjOOTFZPUcA=
 golang.org/x/sys v0.29.0/go.mod h1:/VUhepiaJMQUp4+oa/7Zr1D23ma6VTLIYjOOTFZPUcA=
 golang.org/x/sys v0.32.0 h1:s77OFDvIQeibCmezSnk/q6iAfkdiQaJi4VzroCFrN20=
 golang.org/x/sys v0.32.0/go.mod h1:BJP2sWEmIv4KK5OTEluFJCKSidICx8ciO85XgH3Ak8k=
+golang.org/x/sys v0.34.0 h1:H5Y5sJ2L2JRdyv7ROF1he/lPdvFsd0mJHFw2ThKHxLA=
+golang.org/x/sys v0.34.0/go.mod h1:BJP2sWEmIv4KK5OTEluFJCKSidICx8ciO85XgH3Ak8k=
 golang.org/x/telemetry v0.0.0-20240228155512-f48c80bd79b2/go.mod h1:TeRTkGYfJXctD9OcfyVLyj2J3IxLnKwHJR8f4D8a3YE=
 golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod h1:bj7SfCRtBDWHUb9snDiAeCFNEtKQo2Wmx5Cou7ajbmo=
 golang.org/x/term v0.0.0-20210927222741-03fcf44c2211/go.mod h1:jbD1KX2456YbFQfuXm/mYQcufACuNUgVhRMnK/tPxf8=
