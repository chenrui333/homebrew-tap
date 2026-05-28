class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.12.8.tar.gz"
  sha256 "0426f8c37739b438521ff51e58fcce10bd6ae78f8a0605aa67f9fa8e28106c3a"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ab48ecffef606759e2597b1264d9855c7229acf816f1f9e31e90a1719cffb38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ab48ecffef606759e2597b1264d9855c7229acf816f1f9e31e90a1719cffb38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ab48ecffef606759e2597b1264d9855c7229acf816f1f9e31e90a1719cffb38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7259d6b58ccea95ed62898da56872b10b3cd2a41ba84ba088f3b70e34d7a5551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b39dabd627d56220de66eb85e2d0ae81a1d1ecea74bd33e38cddbd5b058a46be"
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
