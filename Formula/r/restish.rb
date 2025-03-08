class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://github.com/danielgtaylor/restish/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "0aebd5eaf4b34870e40c8b94a0cc84ef65c32fde32eddae48e9529c73a31176d"
  license "MIT"
  head "https://github.com/danielgtaylor/restish.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"restish", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/restish --version")

    output = shell_output("#{bin}/restish https://httpbin.org/json")
    assert_match "slideshow", output

    output = shell_output("#{bin}/restish https://httpbin.org/get?foo=bar")
    assert_match "\"foo\": \"bar\"", output
  end
end
