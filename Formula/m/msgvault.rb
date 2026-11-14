class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "2f819b889e6968afd18646d78f7c3a0975d1fda51e53fc96e8d69a705b910530"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fc96234dfc84da5dea3b1c6cd6c52b4ec91428584e5d9cdda26985011f83c0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e5298bfea26dd7d4752d0e2d5a9536e8b7d37f1c35ad8598cee5981989ce107"
    sha256 cellar: :any,                 arm64_linux:   "d26bd8f2e57e2b4f9dfdfabd2b4212cfc85f6183fab2fc2e18dd21ba72771530"
    sha256 cellar: :any,                 x86_64_linux:  "d38e2e1ca28662da87cb051deea5c673f8809acc3c8ae246e069220d1f5e5f6a"
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
