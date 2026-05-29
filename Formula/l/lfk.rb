class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "6e548b7848e851d3d91e86d416c4447af3580317c88844a543c06156183b0192"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87da50b84055aa21f8d8ef92bc3cbfa913b134097cbb57b3d15543550f40b92f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87da50b84055aa21f8d8ef92bc3cbfa913b134097cbb57b3d15543550f40b92f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87da50b84055aa21f8d8ef92bc3cbfa913b134097cbb57b3d15543550f40b92f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "086cbb78e7fcccda698fe1e6da35bf2bac0cdfef21dd48ce48f085cc128068c2"
    sha256 cellar: :any,                 x86_64_linux:  "92f6c20d0d8cc8d0e69e061ece27e2e713e58b6c1184a5ed8b519f28bed8805d"
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
