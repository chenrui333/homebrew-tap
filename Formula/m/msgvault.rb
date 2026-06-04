class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "f088aecf74f633ac364a1a321475efdf2c9f739576765ac1f028bc0e96c5331f"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72d51720ceea4473c4ba4e3cd26c0e1690ab27d586a58e60b02003ca6c1e8877"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d61f32cc5d8a36b838a0e5d0cb6735db73f41ffae93a84a7179c7e05caec8df9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ede2055e958a40eb0f12eacf33273541a1cfa98c2d40591a26ff2119edec5703"
    sha256 cellar: :any,                 arm64_linux:   "c8181cedc540f8ca73a170abd80582210cd17a8307e8319d3e7b20bec1cb051f"
    sha256 cellar: :any,                 x86_64_linux:  "715fb62f40bb1be5bf17436a023c179c989cf2524b59937fdf986a5a1f9b4dd5"
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
    generate_completions_from_executable(bin/"msgvault", "completion")
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
