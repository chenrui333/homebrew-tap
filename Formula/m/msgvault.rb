class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "d4e97b8098ad3eaeb85b11ec157619045118d36fc14b1761921b67013d410f09"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c60d8fc9dfc2c8f94f96088458341da96b7b9d9c7cc02a0017ccad8b136fa320"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f481690f69b1a2bf15f24149be1e263b1b1b945e9c3b3e8de4b9b75eaf2c965"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a43a63877761ba8926fa54d16e039b2383fea605a2324830c0942b89105f39e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a013175b254ccca80193cb29a38766a321771cd318c52c6ecf5a59c18c639e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60580e90f938a63394b1f2c8649983d380933b7da768bf3a51bfc627939a4e0"
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
