class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "2aa8dc6c3228acb8d94920714fe32617dfd85dc6d02d3aa9c0d511df9e330401"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d5c141de16240d1d47bb0d9e5336e652ed32a3cbdd78ba418c501b16ca4cbb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c19e8eef6e632f9938fa55ce79b6dbdf32b18d83c1959dfa8c912b404adde364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "595e2b67d151dcbeaa64a42099a57622902d6d13eee9b5253fc1ec4bb3095bfa"
    sha256 cellar: :any,                 arm64_linux:   "57fa5cdd36c23d91f5b9db02b4ad92e5df975b677c12ecb7fc7c9fa0276e2662"
    sha256 cellar: :any,                 x86_64_linux:  "aecfd836d0d89777c7d8c7548a2b5aa91fcdebe80766bae368d15387030a6fbf"
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
