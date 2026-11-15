class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "be0b82d9e6a75bd35c9a99cfb268b60f5e1b9911dfb5538467e1b3d0b6ac5be0"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f87f46d5f12a6725e5b85461a8b79d3010b7fe9694c64bf97a6759e40a0df315"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84ff054fa3a22e4c370987d0d3662ad84461db524b45f31dbdbbcce23570618"
    sha256 cellar: :any,                 arm64_linux:   "b024ad7d0348c28800f5144d452516da966c2b0d815fd0847b3d8eb5e5229f50"
    sha256 cellar: :any,                 x86_64_linux:  "540e321afb19c9ee550c9c5f1938dce0e3e836a1d641466bab4bfc0bb4b28935"
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
