class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.14.tar.gz"
  sha256 "e088972be210e018de2a612c3d16857ec79d51206d0c41cc3eaa319daba84110"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3af3bc37f14df670e0f87a3ab53b2ca23d00acbab104d823af6e767cef3dc2a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3af3bc37f14df670e0f87a3ab53b2ca23d00acbab104d823af6e767cef3dc2a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f212adc67e83876a2af523e92f8fe4e279880c3985027203d4f57749e8950019"
    sha256 cellar: :any,                 x86_64_linux:  "a3e012f2b6adb9c9bd7015b2db6b7e14bb7ed367fc936f5cfc879f4c70b646e4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
