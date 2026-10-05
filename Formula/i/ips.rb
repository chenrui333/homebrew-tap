class Ips < Formula
  desc "Geolocation databases tool"
  homepage "https://www.goips.org/"
  url "https://github.com/sjzar/ips/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "74ceffc70398fefd5f5e0e083a53fcbbe7a8a9e90c20f2cdf1f7a45e4413523f"
  license "Apache-2.0"
  head "https://github.com/sjzar/ips.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bab510d68302ab36a1e1ec231e97e0a0d564e9e7ba1777ad65eead96f1f05897"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bab510d68302ab36a1e1ec231e97e0a0d564e9e7ba1777ad65eead96f1f05897"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52f9c02d67c2ca273bed7d0427465dd28acb1b6c924a41e666cf52bd76533a5a"
    sha256 cellar: :any,                 x86_64_linux:  "632a853914d23312998c352594b96178940ca584f062e862150c3f567ba4e942"
  end

  depends_on "go" => :build

  patch :DATA

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/sjzar/ips/cmd/ips.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ips version")

    assert_match "IPS CONFIG", shell_output("#{bin}/ips config")

    (testpath/"geo.txt").write <<~EOS
      # Meta: {"IPVersion":1,"Fields":["country","city"]}
      0.0.0.0/1\tLowland,Alpha
      128.0.0.0/1\tHighland,Beta
    EOS
    output = shell_output("#{bin}/ips -i #{testpath}/geo.txt --format plain --use-db-fields 8.8.8.8 200.1.1.1")
    assert_match "Lowland", output
    assert_match "Highland", output
  end
end

__END__
diff --git a/cmd/ips/cmd_version.go b/cmd/ips/cmd_version.go
index 080439a..3c6face 100644
--- a/cmd/ips/cmd_version.go
+++ b/cmd/ips/cmd_version.go
@@ -42,7 +42,7 @@ var versionCmd = &cobra.Command{
 	PreRun: func(cmd *cobra.Command, args []string) {
 		if bi, ok := debug.ReadBuildInfo(); ok {
 			buildInfo = *bi
-			if len(bi.Main.Version) > 0 {
+			if Version == "(devel)" && len(bi.Main.Version) > 0 {
 				Version = bi.Main.Version
 			}
 		}
