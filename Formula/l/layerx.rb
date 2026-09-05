class Layerx < Formula
  desc "Inspect Docker image layers"
  homepage "https://github.com/deveshctl/layerx"
  url "https://github.com/deveshctl/layerx/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "112bc3c115c817fee7d73cf0ea67542c2f9ce4fca4cc3edfe1500ee5a8cfde32"
  license "MIT"
  head "https://github.com/deveshctl/layerx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f433ed30bb02bbc094e0a452df9bf9549da66bb6ae4691aa64f3c56495009c12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f433ed30bb02bbc094e0a452df9bf9549da66bb6ae4691aa64f3c56495009c12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f433ed30bb02bbc094e0a452df9bf9549da66bb6ae4691aa64f3c56495009c12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "261470a15d62be4b495b1c511990cdab30b2e064860bf10ab240d0d2c5c47133"
    sha256 cellar: :any,                 x86_64_linux:  "410a175e60a24755919129857e4497a6e107bc71dffde9eb39c91a93c45d523e"
  end

  depends_on "go" => :build

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
