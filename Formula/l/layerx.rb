class Layerx < Formula
  desc "Inspect Docker image layers"
  homepage "https://github.com/deveshctl/layerx"
  url "https://github.com/deveshctl/layerx/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "0d69a72a602acf07dc8832c960fcb8d9321538f96375f063d0a9386ea233da2b"
  license "MIT"
  head "https://github.com/deveshctl/layerx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92d59f3b50fa85749b36edff0fb6f6055f22f7bb9888c0bc1d26554d784b3784"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92d59f3b50fa85749b36edff0fb6f6055f22f7bb9888c0bc1d26554d784b3784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2f0ba84f3c46d70dd482d0991fc63874e55767919f78685cd56be8e0fd1f77a"
    sha256 cellar: :any,                 x86_64_linux:  "e1cd67beaaab7c2ec78c32702c59aedc9655035dd6f531c7926a827f445f4fdb"
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
