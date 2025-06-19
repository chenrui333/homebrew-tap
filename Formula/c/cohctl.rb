# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.0.tar.gz"
  sha256 "ddac23630ff1fe9416c0ddca9ed785baa6d884b79cfe515b853c3a6d1595a61c"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3134ee827ea9340e6b467f2bae0037bef03b88de9f436d604297fe5fc30e98af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06528370fe4eca278c4582e45ec052d953e56997a443e4eca97cc3b2250fd777"
    sha256 cellar: :any_skip_relocation, ventura:       "36791fc3669ee11e07f0880c90658d3ebd42ffc6c1da8ed189aa52c4b909e823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e1c6e4937c3b132f5703386935a46196092c4585286ab02e4184f23f0c8cc68"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user} -X main.Date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cohctl"

    generate_completions_from_executable(bin/"cohctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cohctl version")

    output = shell_output("#{bin}/cohctl describe cluster test 2>&1", 1)
    assert_match "unable to find cluster with connection name test", output
  end
end
