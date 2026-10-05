class Layerx < Formula
  desc "Inspect Docker image layers"
  homepage "https://github.com/deveshctl/layerx"
  url "https://github.com/deveshctl/layerx/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "112bc3c115c817fee7d73cf0ea67542c2f9ce4fca4cc3edfe1500ee5a8cfde32"
  license "MIT"
  head "https://github.com/deveshctl/layerx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "965bbd7ee3211e9a4e4ee0600951ba1681fa62e030a153e8807a3a1492e343f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "965bbd7ee3211e9a4e4ee0600951ba1681fa62e030a153e8807a3a1492e343f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b68b7d9aabea427be5de507882238e7ffb35a75d57723ca9f37551f51e4fe18"
    sha256 cellar: :any,                 x86_64_linux:  "a07e75222b35288e8e6b84981fd05166b81dd2de6ffcd01dbbce8eff78426d11"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"layerx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/layerx --version")
    output = shell_output("#{bin}/layerx --engine invalid example 2>&1", 2)
    assert_match 'invalid engine "invalid"', output
  end
end
