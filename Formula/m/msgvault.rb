class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "11e6d5780cfd798c3e17eaedb96b961a7df5dec06a33b9898e882f510682de7a"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fb6ea4d32a61f3a087132a031551f66d2cb5b93040ac8c02cd0a3717dbbda3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "def1ea52364b5e2e442102e03e1d8cfd151a4b68956667647e02b9cbb223073c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ee0e78338feb4362a117c3e127e50a5d1a3225aea30039a35e6391f69370ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f94e66b8007647d3ab00195d1bc918468a1cf301cfab0572e36e537f11d2f11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a1fbeb6109c0f58a7a2a1665fb4f9e22719664ea65fe71f2354a5859b1f8c22"
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
