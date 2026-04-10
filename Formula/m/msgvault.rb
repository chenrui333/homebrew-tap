class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "acbf5f786e69225a5a2d6375bf169445d4440c44b5ea3946745c10a332bd3668"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd83c1c45bf79cda0d1fa438445c7bc4a29931fdd0c432245a676ad84beb621f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2e1a250bf56879eafb621538e1790853dda18a629b2a25f9bebffbe430096dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b935b74a90cf8fab6eab60be837e9ca1409c6ac9b8fa23b5953996edd2d162b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90679e9bc67b0a605827bda270849a9bc8b9222ec13bb5545b432da8587d7799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05b4d26d847735d6fd76f8a5eefae9e5681c12db1775f3dbc95ca548f6ed141f"
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
