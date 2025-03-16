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
