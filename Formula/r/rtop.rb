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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f4250d7f5e5b5f15a387c11080bd964dc5547a357a712172c9be33569981d69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f4250d7f5e5b5f15a387c11080bd964dc5547a357a712172c9be33569981d69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f4250d7f5e5b5f15a387c11080bd964dc5547a357a712172c9be33569981d69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05f4f2e5567243aef4c9d15f47b457c586548153ce35a4119cfc2a4e2447097c"
    sha256 cellar: :any,                 x86_64_linux:  "574ab7317b70aa4e0085777e23db781b98a008bb7e18a3ad314d6acf5f7328f9"
  end

  depends_on "go" => :build

  patch :DATA

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"rtop", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "rtop monitors server statistics", output
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
