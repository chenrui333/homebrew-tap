class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c51859c36619803a1fc9529ed03b69161ababc28ce32334e66d4e748ab4cfd02"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90fb6000eadb4de4063e91fc85cfa6f52b31e6c3c9f8bcc2286d4084cbb65d24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "387c164fd32d5a0d323d31bc15f490cb20bb96b41dcaad8cd4809d6b8e379694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab7f5569cd007455656f6951c16249cd3258a5b1d6053eac79dd9d38ba22d97b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d79572cd526a37760447934172bdd7f487bd4f838cc99093d5a556cc00708fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78c36891c388b3e4de2331180d8647633b0ddcca28a9acfd51e74f184ff9a8ab"
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
