class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "c23fc6fb9ec986aaf5a2ce7d18691f09c6ca18cefe80e38a8e6d5790e3f73ff1"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b596aa7a8151d9ce85de565cded85f205843089a98db2ed309c1e49d46cd807c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2e6ed6f0d1a5c0472397a3526c6576de8ce2acfed1f496a80b22288a76d3dff"
    sha256 cellar: :any,                 arm64_linux:   "12050cf24a483fa9505aaf37225f4d49c33be7ff988749efb140f47010d52aaa"
    sha256 cellar: :any,                 x86_64_linux:  "307b72b003ee54b0e935a0eeda665f69e9229deaf8f973ce13bc53c6bb56d459"
  end

  depends_on "go" => :build

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
