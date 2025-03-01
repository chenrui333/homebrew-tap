class Rtop < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/rapidloop/rtop"
  url "https://github.com/rapidloop/rtop/archive/4dcd50bfc7e307c670048f80a1dc4cdcf4874872.tar.gz"
  version "1.0"
  sha256 "a706d6cddf8d2782d47a63e118dddf856d99bd9172000f4d1f3350704d98747f"
  license "MIT"
  head "https://github.com/rapidloop/rtop.git", branch: "master"

  livecheck do
    skip "no recent releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3622c0f9ede688f65abb11ee96e23c0385751eeebbb40a6747595dafa655d87e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faa2a84a54bf18192281a6cae1187551cd64d47f1d98f9bb4643b99f32dc0f12"
    sha256 cellar: :any_skip_relocation, ventura:       "5b4da2d0b4df993925142a10b2be6cabf253f1428604f681f84dab59c5f6fe1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1a1da80d1b277711a4e3d9c4fa6bc5d97c442f4cb05d414b1438dbdab33442b"
  end

  depends_on "go" => :build

  patch :DATA

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtop --help")
  end
end

__END__
diff --git a/go.mod b/go.mod
new file mode 100644
index 0000000..12169ef
--- /dev/null
+++ b/go.mod
@@ -0,0 +1,14 @@
+module github.com/rapidloop/rtop
+
+go 1.24.0
+
+require (
+	github.com/mattn/go-colorable v0.1.14
+	golang.org/x/crypto v0.35.0
+)
+
+require (
+	github.com/mattn/go-isatty v0.0.20 // indirect
+	golang.org/x/sys v0.30.0 // indirect
+	golang.org/x/term v0.29.0 // indirect
+)
diff --git a/go.sum b/go.sum
new file mode 100644
index 0000000..7fd2a4c
--- /dev/null
+++ b/go.sum
@@ -0,0 +1,11 @@
+github.com/mattn/go-colorable v0.1.14 h1:9A9LHSqF/7dyVVX6g0U9cwm9pG3kP9gSzcuIPHPsaIE=
+github.com/mattn/go-colorable v0.1.14/go.mod h1:6LmQG8QLFO4G5z1gPvYEzlUgJ2wF+stgPZH1UqBm1s8=
+github.com/mattn/go-isatty v0.0.20 h1:xfD0iDuEKnDkl03q4limB+vH+GxLEtL/jb4xVJSWWEY=
+github.com/mattn/go-isatty v0.0.20/go.mod h1:W+V8PltTTMOvKvAeJH7IuucS94S2C6jfK/D7dTCTo3Y=
+golang.org/x/crypto v0.35.0 h1:b15kiHdrGCHrP6LvwaQ3c03kgNhhiMgvlhxHQhmg2Xs=
+golang.org/x/crypto v0.35.0/go.mod h1:dy7dXNW32cAb/6/PRuTNsix8T+vJAqvuIy5Bli/x0YQ=
+golang.org/x/sys v0.6.0/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
+golang.org/x/sys v0.30.0 h1:QjkSwP/36a20jFYWkSue1YwXzLmsV5Gfq7Eiy72C1uc=
+golang.org/x/sys v0.30.0/go.mod h1:/VUhepiaJMQUp4+oa/7Zr1D23ma6VTLIYjOOTFZPUcA=
+golang.org/x/term v0.29.0 h1:L6pJp37ocefwRRtYPKSWOWzOtWSxVajvz2ldH/xi3iU=
+golang.org/x/term v0.29.0/go.mod h1:6bl4lRlvVuDgSf3179VpIxBF0o10JUpXWOnI7nErv7s=
