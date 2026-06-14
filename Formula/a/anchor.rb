class Anchor < Formula
  desc "CLI for anchor.dev"
  homepage "https://anchor.dev/"
  url "https://github.com/anchordotdev/cli/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "02b2f7de0443d6ddfb2d54cd198b7e4f263f94bd4bf438737563d5d19cb88add"
  license "MIT"
  head "https://github.com/anchordotdev/cli.git", branch: "main"

  depends_on "go" => :build

  def install
    # Homebrew manages updates, so disable the post-run network release check.
    inreplace "cmd/anchor/main.go",
              "cli.CmdRoot.PersistentPostRunE = versionpkg.ReleaseCheck",
              "cli.SkipReleaseCheck = true\n\tcli.CmdRoot.PersistentPostRunE = versionpkg.ReleaseCheck"

    # Upstream renders version output through Bubble Tea, which can deadlock in non-interactive CI.
    inreplace "cmd/anchor/main.go",
              "func main() {\n\t// prevent delay/hang",
              "func main() {\n\tif len(os.Args) == 2 && os.Args[1] == \"version\" {\n" \
              "\t\t_, _ = os.Stdout.WriteString(cli.VersionString() + \"\\n\")\n" \
              "\t\treturn\n\t}\n\n\t// prevent delay/hang"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=homebrew
      -X main.date=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/anchor"

    generate_completions_from_executable(bin/"anchor", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/anchor version")

    output = shell_output("NON_INTERACTIVE=1 #{bin}/anchor not-a-command 2>&1", 1)
    assert_match "unknown command \"not-a-command\" for \"anchor\"", output
  end
end
