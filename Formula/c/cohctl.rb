# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.3.tar.gz"
  sha256 "e5285aa467c449098f16ceab38a2337e17418c81ebe10063abb42afccaa74489"
  license "UPL-1.0"
  revision 1
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf86269faba76fa2c0c5dfe0a954798b149f736f589cc454967510483d77d5d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf86269faba76fa2c0c5dfe0a954798b149f736f589cc454967510483d77d5d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf86269faba76fa2c0c5dfe0a954798b149f736f589cc454967510483d77d5d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85b6aaa37890a6e7ed386958610a11c361bd45c1c3b083324a1d76bf42ef26d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bff3b8ff01b6e9874ea461e9ffcdea2370a10a49c6183fbb961de3ff15556d0d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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
