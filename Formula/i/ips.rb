class Ips < Formula
  desc "Geolocation databases tool"
  homepage "https://www.goips.org/"
  url "https://github.com/sjzar/ips/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "74ceffc70398fefd5f5e0e083a53fcbbe7a8a9e90c20f2cdf1f7a45e4413523f"
  license "Apache-2.0"
  head "https://github.com/sjzar/ips.git", branch: "main"

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
