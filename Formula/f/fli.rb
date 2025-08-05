class Fli < Formula
  desc "CLI for AWS VPC Flow Logs analysis"
  homepage "https://github.com/fractalops/fli"
  url "https://github.com/fractalops/fli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4b3c7c454fef762209b4fe879e205ecbc51126625172675ad1ea8f60dc47df82"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fli"

    generate_completions_from_executable(bin/"fli", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    output = shell_output("#{bin}/fli --dry-run count --by srcaddr --since 1h --log-group test")
    assert_match "FLI Query Configuration", output
  end
end
