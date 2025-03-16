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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a81eedf0cd627688f557975f663644d95da74ed051d3daa09a2779c4fdd213af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "822f12d525a589421f15d5113c516abb394aa00e22caa8bb56a9a1e1e52cb0ca"
    sha256 cellar: :any_skip_relocation, ventura:       "f31317374deba491b108c69f874955416c1195ad20daa20d42333b987d54d1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68401c7c33380e5e0116b72b23ad6ab7b0ac154025ea1d2009d79b7870e99033"
  end

  depends_on "go" => :build

  patch :DATA

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"krs", "--help"
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
