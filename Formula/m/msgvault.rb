class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "25285e2281238e64f5c72c1a1cc54e8a3f0351b76ea6dfb7c6971f4566276e4f"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "498623e6c1eca706ee9d0d7cc89a3ddcdf397f1fe5b4d7dc31e6f9518585d3b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbc3d8c89ff2f9e4b403a0394cb2158588938cd29aef1e43a01b82042401d1c3"
    sha256 cellar: :any,                 arm64_linux:   "db365fac54a4cb98ed0bdecf9b802a39d8c60c503464d0d7c949295605ca88c2"
    sha256 cellar: :any,                 x86_64_linux:  "94cff3ec50e2df9d65eb055b0596003336fe7c5832d904e5282d97e4be661c88"
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
