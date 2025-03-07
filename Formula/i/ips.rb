class Ips < Formula
  desc "Geolocation databases tool"
  homepage "https://www.goips.org/"
  url "https://github.com/sjzar/ips/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "74ceffc70398fefd5f5e0e083a53fcbbe7a8a9e90c20f2cdf1f7a45e4413523f"
  license "Apache-2.0"
  head "https://github.com/sjzar/ips.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cebee234c59559a8337a9fad8938fbb847d63c5f6968961e0796046330c6bf21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b0b736eb02c3c35d01b02cd9b22bf8d3feb2b3eeb5b67e090c982a20f214a49"
    sha256 cellar: :any_skip_relocation, ventura:       "da3286b1dba6efec63f7c90e575faa6b4e088f152ad2e6b86bba50852f502041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f72952d27065f3958e244c636d4e4ecdd0178d7d20361ef9af17fcae721f821d"
  end

  depends_on "go" => :build

  patch :DATA

  def install
    ldflags = "-s -w -X github.com/sjzar/ips/cmd/ips.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ips version")

    assert_match "IPS CONFIG", shell_output("#{bin}/ips config")
    system bin/"ips", "myip"
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
