class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "e22f1a5088a46ca1a898dcb7ccabc9f55c41e5f936bed737e4254cb7f2694c94"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74aaed48ea6431c48e7a179ba243774dc69f673bd26b6f82c549e945ec7e9d46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74aaed48ea6431c48e7a179ba243774dc69f673bd26b6f82c549e945ec7e9d46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74aaed48ea6431c48e7a179ba243774dc69f673bd26b6f82c549e945ec7e9d46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "900b9b2af4c714995bb9d4cad01c687f6175daff3b8ce0dfeb61bbae368a4155"
    sha256 cellar: :any,                 x86_64_linux:  "68cbfd9b63727d2747efe682ca24bda8f97e3a363f4558846a152ec77c877b18"
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
