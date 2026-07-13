class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "ffadb982007edb77c48942d5c14798f20840862bf39f905e256db176ff3d221b"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3a18d318a19fe228ccd0d474255a686f651de1b8755e5857ed6d801604c40d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f6d89826b96146a86eda7a8026580b61df68d7138b1feba97f550ccfa1972b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a0da8e82ff0d4dff4ebb3cb3408403e3571a1b78180cf0a560c88a5b923a558"
    sha256 cellar: :any,                 arm64_linux:   "70f571d65a4ec02e08f8b249459a83502dddab696709f7ca9d5816262aada667"
    sha256 cellar: :any,                 x86_64_linux:  "15f04b95503a9f85ddd9df6596d3ab8f89c2260956eb9a4ec104eb0fc11e8405"
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
