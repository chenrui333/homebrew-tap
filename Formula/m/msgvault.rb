class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "2aa8dc6c3228acb8d94920714fe32617dfd85dc6d02d3aa9c0d511df9e330401"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "348256d86a0d038c447ce1ef9ce73d88dfd05120f3016b6bce60e0c3d7fd53a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2704d3bfb6677a519fc9813b6316d348f41040d217e122af876b776fb8e20eb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df26d991dc3795a9cc803603efb914de51201f2fefad3dcb57bfe10c4dd61966"
    sha256 cellar: :any,                 arm64_linux:   "3f13c4f5080338795dbdf6e7f99a330990f07d5bb080ad7e1cea2112c9955ef4"
    sha256 cellar: :any,                 x86_64_linux:  "315100fd6ca1b6d575586b11baca09e732f69d78b66376826b77ac0cf4c50c53"
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
