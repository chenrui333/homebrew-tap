class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "712be65ee754f2bf349efb9aaef54f5492023d0f5d3436ed5bc83afb40e5e12b"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a45fb45a136b5e6347781afdabc02579169914eb116e425647363ba5226177d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e41a7a918f4e9d91f0e3a15c2d6aee1e14ded3e3c8e014206a94443af11790c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96d26ab601ec31021a3bda0366700c0eabe20340d864343fbba2c29fb8758574"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cd4c2cda465ddbe462c47829eded3713a9b67d68256200f3e849f113301a21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8d86747a334f6abf8627751eb8ecb73d21d8dbd7439fc4e277bfaa758813701"
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
