class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "0d4007d046b754c8b80975077bbed48d0aa214ac555b3e1ac7de7679560d8d12"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03f88fb7c3f196744edf8119f82d1741ba081c5e17fddebfc70225f24bfb32ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fbc74b3e117d64aeeefbc4cfd517f8b9a69168b688ef2c5c4c893c9b790a4c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82150fd7cb6da294d869af3222dbd1a0c10e2f899262e22824639ad7a7c431a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef2b6e891cb59d889dc5ce61d7bb8f46d180d9c9f95ff29ae642e9e87b816872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1a00c8567536107098ae94df555bea963508db4293e7ce67399b39933b6391e"
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
