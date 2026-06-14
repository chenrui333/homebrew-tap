class Krs < Formula
  desc "Capturing and serializing k8s resource statistics in OpenMetrics format"
  homepage "https://mhausenblas.info/krs/"
  url "https://github.com/mhausenblas/krs/archive/refs/tags/0.2.tar.gz"
  sha256 "be745bd8c96a95a06f453bdc55e893b5afcdf305a622e94a76af054ae61d1b56"
  license "Apache-2.0"
  head "https://github.com/mhausenblas/krs.git", branch: "master"

  livecheck do
    skip "no recent releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dad957b08a1914a58b17aa049a8ac56ec38c5559534bd37895b2f4c3a36c6fa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dad957b08a1914a58b17aa049a8ac56ec38c5559534bd37895b2f4c3a36c6fa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dad957b08a1914a58b17aa049a8ac56ec38c5559534bd37895b2f4c3a36c6fa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98d7f2abfdc22908939421fc7d8b12f733e6490a61941863181feef81febcac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a70d66edcd9e6f0e1b522b7434d86e9bc61b7eae7793877e5d748685406457a"
  end

  depends_on "go" => :build

  patch :DATA

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"krs", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

__END__
diff --git a/go.mod b/go.mod
new file mode 100644
index 0000000..4837710
--- /dev/null
+++ b/go.mod
@@ -0,0 +1,5 @@
+module github.com/mhausenblas/krs
+
+go 1.24.1
+
+require github.com/mhausenblas/kubecuddler v0.0.0-20181012110128-5836f3e4e7d0
diff --git a/go.sum b/go.sum
new file mode 100644
index 0000000..df1f07f
--- /dev/null
+++ b/go.sum
@@ -0,0 +1,2 @@
+github.com/mhausenblas/kubecuddler v0.0.0-20181012110128-5836f3e4e7d0 h1:TZSzAlXKCKnstV6euLVFkwI4gHudDPoLqq3/kBaR3PI=
+github.com/mhausenblas/kubecuddler v0.0.0-20181012110128-5836f3e4e7d0/go.mod h1:6FIXVGLaL5pg6GSkmkDEY1TaRCNySC7DdR+/PF0OClo=
