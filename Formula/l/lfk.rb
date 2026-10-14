class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "04d4e8684a7a66496a559047fb7dc64e097b497b84df9acdd0eefd5aee1ffef9"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd2c5f80a8f9d20cb2787b4a7b3232686a66addfd448c254cae84736eb3b39cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd2c5f80a8f9d20cb2787b4a7b3232686a66addfd448c254cae84736eb3b39cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0686508951969d75a47e9260e2cec57cd1dfb267e34a30e0d52ddbf52e3a5342"
    sha256 cellar: :any,                 x86_64_linux:  "300f613d30b9781b13d63ee0e53033011d6ef3c7fe773e88234b0d59b4849d39"
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
