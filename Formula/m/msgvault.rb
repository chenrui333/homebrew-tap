class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "a751a9d20b13cd23195deb1796e45f81ef5bf0742122f5d056321fb53f14fa03"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ddecae2a4d990261db765d44f66f630bcf85dd20a9039b57f0c69ae59c85e5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b4d75babd70a2dd64ac947dfb17298a0c4ffb47bd8b946da6a0dad2314a6b83"
    sha256 cellar: :any,                 arm64_linux:   "ca07ab876971c602dac8a9e5a67dc9aa3a6e02c3329af59fbf474cb6b0946565"
    sha256 cellar: :any,                 x86_64_linux:  "5b82b0f778bb125753c451ee632050763f8a504b5e752d2c154af20d6739a5c1"
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
