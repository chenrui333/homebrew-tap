# framework: urfave/cli
class Lintnet < Formula
  desc "General purpose linter for structured configuration data powered by Jsonnet"
  homepage "https://lintnet.github.io/"
  url "https://github.com/lintnet/lintnet/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "b8f9163b21ab95ee5bbdb80a6670b9d47ded16fa30e7f9b915c7a0360ec21831"
  license "MIT"
  head "https://github.com/lintnet/lintnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90286e30085f6161f727bb82d7f5d5a19788899a036913819280f727c30b1f53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90286e30085f6161f727bb82d7f5d5a19788899a036913819280f727c30b1f53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cbbb3c8acbdf8a94d49ebf1b40759dfb77c1b4e002d2dc937b7e93e1a9327df"
    sha256 cellar: :any,                 x86_64_linux:  "be1f6ed2a54dab8ddd07cf5ae9f90d9fa916045da96e6e9be0b43e9ba34cf037"
  end

  depends_on "go" => :build

  # add completion compatibility patch
  patch :DATA

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lintnet"

    generate_completions_from_executable(bin/"lintnet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lintnet version")
    assert_match version.to_s, JSON.parse(shell_output("#{bin}/lintnet info"))["version"]

    system bin/"lintnet", "init"
    assert_match "A configuration file of lintnet", (testpath/"lintnet.jsonnet").read
  end
end

__END__
diff --git a/pkg/cli/runner.go b/pkg/cli/runner.go
index 01bd584..65ab375 100644
--- a/pkg/cli/runner.go
+++ b/pkg/cli/runner.go
@@ -13,6 +13,21 @@ type GlobalFlags struct {
 	Config   string
 }
 
+// normalizeArgs rewrites "completion powershell" to "completion pwsh" for Homebrew compatibility.
+// Homebrew's generate_completions_from_executable calls "completion powershell",
+// but urfave/cli/v3 only recognizes "pwsh", not "powershell".
+// This function treats "powershell" as an alias for "pwsh".
+func normalizeArgs(args []string) []string {
+	// Check if args match: [<program>, "completion", "powershell", ...]
+	if len(args) >= 3 && args[1] == "completion" && args[2] == "powershell" {
+		// Copy-on-write: create a new slice to avoid mutating the original
+		normalized := append([]string(nil), args...)
+		normalized[2] = "pwsh"
+		return normalized
+	}
+	return args
+}
+
 func Run(ctx context.Context, logger *slogutil.Logger, env *urfave.Env) error {
 	gFlags := &GlobalFlags{}
 	return urfave.Command(env, &cli.Command{ //nolint:wrapcheck
@@ -46,5 +61,5 @@ func Run(ctx context.Context, logger *slogutil.Logger, env *urfave.Env) error {
 			}).command(logger, gFlags),
 			(&newCommand{}).command(logger, gFlags),
 		},
-	}).Run(ctx, env.Args)
+	}).Run(ctx, normalizeArgs(env.Args))
 }
