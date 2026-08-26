class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "39aeee0d7727f607b7c8a0a341bbbdb126419544825d09da7b72a92f71b10457"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "853c5d5b6b7a2626b5f22a1c06440d45bd8e92a9b392faa231305e69c88aa87a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "853c5d5b6b7a2626b5f22a1c06440d45bd8e92a9b392faa231305e69c88aa87a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "853c5d5b6b7a2626b5f22a1c06440d45bd8e92a9b392faa231305e69c88aa87a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b68c6510595f65a908f6e06c5537837aadaac2d6ca5f2ff113826f0504f0db6f"
    sha256 cellar: :any,                 x86_64_linux:  "b5c4078d8eb20c9ab33f1748b26a9737fa1dc6ede3b333d4c9c7831993cf8f35"
  end

  depends_on "go" => :build

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
