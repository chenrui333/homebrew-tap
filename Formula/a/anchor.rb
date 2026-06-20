class Anchor < Formula
  desc "CLI for anchor.dev"
  homepage "https://anchor.dev/"
  url "https://github.com/anchordotdev/cli/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "02b2f7de0443d6ddfb2d54cd198b7e4f263f94bd4bf438737563d5d19cb88add"
  license "MIT"
  head "https://github.com/anchordotdev/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4095010e419667119b5cff03c7481e50320421944d260f2ede5a071b90828e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4095010e419667119b5cff03c7481e50320421944d260f2ede5a071b90828e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4095010e419667119b5cff03c7481e50320421944d260f2ede5a071b90828e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a6a5da8cd702b9d8d582f64e80386a8a1b86e58063e6262c4ad6406e876f3e1"
    sha256 cellar: :any,                 x86_64_linux:  "3cf3be047855fea8ef0140cdc0a64e39e3dc292dfe6ba615470afcb113d11bb4"
  end

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

    generate_completions_from_executable(
      bin/"anchor", shell_parameter_format: :cobra, shells: [:bash, :zsh, :fish, :pwsh]
    )
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/anchor version")

    output = shell_output("NON_INTERACTIVE=1 #{bin}/anchor not-a-command 2>&1", 1)
    assert_match "unknown command \"not-a-command\" for \"anchor\"", output
  end
end
