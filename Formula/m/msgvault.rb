class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "2a22212f6f022546002e401c8c1d5f68f236821f171adbfb03dd3c4bc6b4f92f"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e3075b401cc4b4a9849a8173f28433dcfe0f3d40eb0f118635e851f380e30c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6baa61fbe74da99853a7e7015e449f917f9beb9c13030b1b76c7e8e88a270359"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89f326bb7266a16223627be7d633b66a842b68e7f2a357bd14b95c22f4f5f8a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb45bec4cf1a25cb4a46169d0d43928f782a39833430a8e961d15a5f52221c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d6f8ed9bf977f1b1b6368f7469bf7ef1cf5bdd5299444e13442b25e40c4830"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/wesm/msgvault/cmd/msgvault/cmd.Version=#{version}
      -X github.com/wesm/msgvault/cmd/msgvault/cmd.Commit=homebrew
      -X github.com/wesm/msgvault/cmd/msgvault/cmd.BuildDate=#{time.iso8601}
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
