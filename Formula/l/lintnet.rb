# framework: urfave/cli
class Lintnet < Formula
  desc "General purpose linter for structured configuration data powered by Jsonnet"
  homepage "https://lintnet.github.io/"
  url "https://github.com/lintnet/lintnet/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c5286cc799333898c1fc74cc27c22a779a6679438fe669351f31236d485e312e"
  license "MIT"
  head "https://github.com/lintnet/lintnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7eb17630ee3a6b688b95d5b4fad3f83273d5a4b38240a24e9c88775712b89a3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eb17630ee3a6b688b95d5b4fad3f83273d5a4b38240a24e9c88775712b89a3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31db902b997af356dff11aee4caf333456657e1fd32ce7f0baaa132b626bd270"
    sha256 cellar: :any,                 x86_64_linux:  "e6b12d0bce454fb4232880651218c2359bbdd74ae3500d536d00c66f7f6bcd1f"
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
