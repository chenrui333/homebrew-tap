class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.15.9.tar.gz"
  sha256 "1201387c1c044df5f37920cb2ed98b90bf0a616c9703c68a9c51a094cf82bf48"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3613753ab8b5f1c1231fff01a92e18c866fc67c3a3e63710506670e0ce03b738"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3613753ab8b5f1c1231fff01a92e18c866fc67c3a3e63710506670e0ce03b738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3613753ab8b5f1c1231fff01a92e18c866fc67c3a3e63710506670e0ce03b738"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b084a6d7ad591d015515e40b38eb6ee65a68ff4fec667a73c8f0c8a82acd3f04"
    sha256 cellar: :any,                 x86_64_linux:  "2cc8adfcea4b9cfee9b3cc22d971594807042eb5418ccb4d01c27985077a3e6e"
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
