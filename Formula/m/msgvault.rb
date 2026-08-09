class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "01290d64a9ff374752ef62b5c7889276385007a58f042e9c9533d30658164074"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b09422ed39c36865fbba6bafd80089d550ba4762d9bea142852f1625249fcaf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a25e5c1ee88375ae97027018d3ba06954e84ca12d44143f35fafea98b06e3ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90217eb9962136bf80e6a58eb3dc9310433e1d9cf579a7b3acdb8cdbc9d04d4b"
    sha256 cellar: :any,                 arm64_linux:   "8bffc6ec7c49433c15e3373fa2252fe4a4dc5f92af2a0d593b7c17a37670db2f"
    sha256 cellar: :any,                 x86_64_linux:  "342eca6417a20e3bef9a480ea02f98730f6577452d619fbc30b092e8d38b266f"
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
