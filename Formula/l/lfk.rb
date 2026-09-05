class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.8.tar.gz"
  sha256 "ea63a7efa1d1b2169b0928a6b692d1984ae0ca7516b3837318c30cf0a88500af"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "638a527cf069973d4bf772210ef84810773faa6c41fd75911d4e9a58fbfd4b07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "638a527cf069973d4bf772210ef84810773faa6c41fd75911d4e9a58fbfd4b07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "638a527cf069973d4bf772210ef84810773faa6c41fd75911d4e9a58fbfd4b07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5edde30d1e8a6a5f1f82d3e9cd4651c5fe41ee08f3f88d15fe98e9d7df64eb4f"
    sha256 cellar: :any,                 x86_64_linux:  "89b978f8bff677aaaae2acb209f9a4b0801a0a74c59b1fc0f83d587887815810"
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
