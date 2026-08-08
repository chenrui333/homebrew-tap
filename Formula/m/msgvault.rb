class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "3c65a6132033b5dab8a1c6638f38590f84b2bb0572b22546e07e6d7f6275a39c"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0358b03f6fa4cb9be5ceda2ce59e7ac82ec5370c31883c9636e74bbd5ba8da6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2b74596bc580a82281bab55b3ef8457e0ca51b083fc99cb5b8549a3d8cb3e32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b3c0a01c3278c6fde74cbbdd7a08c11a73bcc020a06971317fbabe1a693d3bc"
    sha256 cellar: :any,                 arm64_linux:   "364b6880908436dd439fdcd04bf4d1cfc3b34d8c7d0b3c6a815a4f327578c903"
    sha256 cellar: :any,                 x86_64_linux:  "b5eb93d10d04170707fdeecbccf34152071de4ec89670f5d89bfdaac1c0620e5"
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
