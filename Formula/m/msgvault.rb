class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "0657a1c4c0be70242fb132b7bd16e3a8d544b600d5641bd2589cf3769eb0c151"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3504886de6def2fdf96d0babbd1f150afe1fb7c0428a550160447eb8e37ccf21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df5388b5fe81bb4ee6314c0c8321628dd80302744c47ca0ac48fd58e1c73188a"
    sha256 cellar: :any,                 arm64_linux:   "9507fc138da34f4f091af1c301a865ac36cf256508fa589fa389c661cf3a6aa9"
    sha256 cellar: :any,                 x86_64_linux:  "21e986d80566e106bbbb75e1164b27f136e5fb554b9d0e9fbe1f3013b2f0c024"
  end

  depends_on "go" => :build

  # CLI commands run through a local daemon that listens on a loopback HTTP port.
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X go.kenn.io/msgvault/cmd/msgvault/cmd.Version=#{version}
      -X go.kenn.io/msgvault/cmd/msgvault/cmd.Commit=homebrew
      -X go.kenn.io/msgvault/cmd/msgvault/cmd.BuildDate=#{time.iso8601}
    ]

    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags:), "-tags", "fts5", "./cmd/msgvault"

    ENV["MSGVAULT_HOME"] = buildpath/".msgvault"
    generate_completions_from_executable(bin/"msgvault", shell_parameter_format: :cobra)
  end

  test do
    ENV["MSGVAULT_HOME"] = testpath.to_s

    assert_match version.to_s, shell_output("#{bin}/msgvault version")

    init_output = shell_output("#{bin}/msgvault init-db")
    assert_match "Database:", init_output
    assert_match "Messages:    0", init_output

    stats_output = shell_output("#{bin}/msgvault stats --local")
    assert_match "Accounts:    0", stats_output
  end
end
