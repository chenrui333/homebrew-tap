class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "49a95c1bf5edb0d37dc7f8e409ed09ac697b2755584f525bbb930c361585059d"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f72b0957b9ae7785811691179dd6586e0deba88f6732afa234b86b0a5599380f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f72b0957b9ae7785811691179dd6586e0deba88f6732afa234b86b0a5599380f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f72b0957b9ae7785811691179dd6586e0deba88f6732afa234b86b0a5599380f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b24720064206e4229eae090d1218fa94c63d3d5ab748709e4f56446ff501a5b2"
    sha256 cellar: :any,                 x86_64_linux:  "ffd9811cdd29efc9d32dcfd9dad0217ca963b4d2a8b5b530ad6416b3323d878a"
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
