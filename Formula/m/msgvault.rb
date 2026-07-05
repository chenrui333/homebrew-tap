class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "7a29b4f136389e18d47d5ac5262ea6c7c286baae42749e3ca110b4c174199397"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7e951b1f0df69dcf5a891e5df908a6e7a8ecbd645f876f80f2774d60666b679"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "026d12ca50eb3a907b526c1a311bc6536f04f11a27c08b687d685a52a3e22e92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "798cd5a6e3edb5cf54adf14ede4ffd4e832641abe8bdf1e19951d824e48b5cf2"
    sha256 cellar: :any,                 arm64_linux:   "5746443583ee03d131c9c894566a0b96483344029df1118578e3e05f0cd70054"
    sha256 cellar: :any,                 x86_64_linux:  "d3fab0cbcda0d4c002db7d514d87046450f289b28b22f019178b76240ae471a1"
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
