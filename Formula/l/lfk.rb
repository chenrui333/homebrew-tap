class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "074d2768d9361ea633ed021f0f6d2c1f6a1320e2ba3ab996d0b00b7ef9d408f1"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8144582baa69bc115c1124231c9351751204c16b07f89c4ff4916dc351637bbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8144582baa69bc115c1124231c9351751204c16b07f89c4ff4916dc351637bbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8144582baa69bc115c1124231c9351751204c16b07f89c4ff4916dc351637bbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6361bfa0dd41d907703622e1544e001ab0ee93a81844a6c31ccf6d53ffd91ca9"
    sha256 cellar: :any,                 x86_64_linux:  "505a34ec4584f892b608b8f2677fa2f128cca8b8b8cc6bfdc3b02dc448159a8d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
