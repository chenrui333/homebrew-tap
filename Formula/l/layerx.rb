class Layerx < Formula
  desc "Inspect Docker image layers"
  homepage "https://github.com/deveshctl/layerx"
  url "https://github.com/deveshctl/layerx/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "80e91a9a6d45a3ba259472cd5b8e2be9db1f6da4be435ef910fd8de63a965427"
  license "MIT"
  head "https://github.com/deveshctl/layerx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "443ab8aec994ccfee759a6215ddc0735b3de7dcafdb5da21cb56f5d7daf813a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "443ab8aec994ccfee759a6215ddc0735b3de7dcafdb5da21cb56f5d7daf813a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad23fbdf1dd75579cbe9806232a9a8ac7c4a4edf0081ecf1e086d7f2060d00dd"
    sha256 cellar: :any,                 x86_64_linux:  "c81f791639a541230e4ca867d1d4a2b785e9e1c2be68883d3820164fef85ea70"
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
