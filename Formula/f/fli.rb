class Fli < Formula
  desc "CLI for AWS VPC Flow Logs analysis"
  homepage "https://github.com/fractalops/fli"
  url "https://github.com/fractalops/fli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4b3c7c454fef762209b4fe879e205ecbc51126625172675ad1ea8f60dc47df82"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2002c05ee259620176bcd617f56ef1bb333d9c0d0b1acbc30e3f8ba4e06c7e56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c13146b44f0be81632a2562106e2eeb45565b272a3fc77d514a3e7c598dce876"
    sha256 cellar: :any_skip_relocation, ventura:       "d1537a0187a381e9344a9a6dc61628692c2d1bccc044e519364e327a39756314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0260b04cca06b68369c3af2df6037580f2f1caca580783fcc8d910642f5674e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fli"

    generate_completions_from_executable(bin/"fli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/fli --dry-run count --by srcaddr --since 1h --log-group test")
    assert_match "FLI Query Configuration", output
  end
end
