class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "25285e2281238e64f5c72c1a1cc54e8a3f0351b76ea6dfb7c6971f4566276e4f"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cec9823121a86e164afc2b9bc83f9d71900617944a04b6fa392292094da3b0f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c113a546e29bf67d5865e9da3e489f75b6152b5795992c780a5aa525517c9df"
    sha256 cellar: :any,                 arm64_linux:   "97d032d257723bd8e8ddba81a0b2ed87e28c098d56fe615aab3faed60ee1257e"
    sha256 cellar: :any,                 x86_64_linux:  "1bbf45f55193c36dbe5e21f4515da2b0edf8b308eac476974a204cbedbb9dbd4"
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
