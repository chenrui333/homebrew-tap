class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "e22f1a5088a46ca1a898dcb7ccabc9f55c41e5f936bed737e4254cb7f2694c94"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbef810dcf4a505944d165f88d050bb7bd65e911e3f153c6454638f1cb4eafcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbef810dcf4a505944d165f88d050bb7bd65e911e3f153c6454638f1cb4eafcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbef810dcf4a505944d165f88d050bb7bd65e911e3f153c6454638f1cb4eafcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38c26c02720bf556b1bc2e207bba69869d5eeeea2240a040c5ca2414b54cbdf0"
    sha256 cellar: :any,                 x86_64_linux:  "871568be71ef2345e5c3defa86839be1a72e1e773413e92138132fa8181cf435"
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
