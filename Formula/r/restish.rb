class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://github.com/danielgtaylor/restish/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "0aebd5eaf4b34870e40c8b94a0cc84ef65c32fde32eddae48e9529c73a31176d"
  license "MIT"
  head "https://github.com/danielgtaylor/restish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a633365b1150e2d24dc329e2ba5fb498c33fcf3c0559ac5676fb366d6b9f0c89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f87ca5beb7181adc229d7c1f18e6ed2f1d04cd6f99f8fe1a34b4d8b397acd06"
    sha256 cellar: :any_skip_relocation, ventura:       "4cfc4140ea5a2d6cb5aabf8f4a4f1d263be998f7d76d8c57ccbd029e215f19a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f4085df6c02b01bc6be788a46f202957d6e3c0a9667494f9d77f6d5cbb4e2df"
  end

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
