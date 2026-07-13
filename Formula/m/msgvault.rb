class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "ffadb982007edb77c48942d5c14798f20840862bf39f905e256db176ff3d221b"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "537716fc41fc0061d29e1c096005903597f9397a872f4bacb788164b5d5a76da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46138e5ae363b643cc046998db465d8493064a94ff42be27228c3f12d9c2919e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "800b44c6248371f38c7ce0d7b53b1b85ae048bb9cf84972ddc88130943584dd1"
    sha256 cellar: :any,                 arm64_linux:   "0bc873bbe292caed838a74f32c73b7a778d22bc45dc03a392b9d0a1632746384"
    sha256 cellar: :any,                 x86_64_linux:  "7b0737a2c4c6dcaf1ba63e11648d4934d3c90516792e3def81ca461eb51daec1"
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
