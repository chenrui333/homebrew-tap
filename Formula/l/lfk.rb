class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.8.tar.gz"
  sha256 "a027d55f7efb4c98373c872465e2e06e112a6e0e008e8d3b6e43ec82b1e39c4b"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc1cb314456b22df64796103dad038e100817c341c4eda3b29fea33c3651447b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc1cb314456b22df64796103dad038e100817c341c4eda3b29fea33c3651447b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d016af8ab1c7353929452e954f2df68c6d67070537cb337de860ee5fd59c5167"
    sha256 cellar: :any,                 x86_64_linux:  "6da81c799e19aca5d28cc5769d7345e6f858975e74a9bb59883da3ce3e9221c5"
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
