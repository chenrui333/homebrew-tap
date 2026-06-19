class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "f088aecf74f633ac364a1a321475efdf2c9f739576765ac1f028bc0e96c5331f"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baee1b431443ef6fb1ae4ef6e2610384275a30dc130b28cee55a0053df71aff5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ef523825a3e2120aa1bfb795d37b90aa19e0597b2b82aec86ade9010b8bb8b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5045141ad38bcf1b7734d1a1c36c328ac15793a286c25e8e5ea9c87f06722063"
    sha256 cellar: :any,                 arm64_linux:   "2b75c9d0f0aa494da160a6380ad2d128fefd1c8165ed30bbc73c1a0844b82bce"
    sha256 cellar: :any,                 x86_64_linux:  "34a139db739bfa0878dd432fb0ce674a8a476befd2da2542adc8174362f57bfd"
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
