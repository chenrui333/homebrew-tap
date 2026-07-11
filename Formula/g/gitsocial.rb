class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "c354f058c2812e5574e5db0fcc4ed9c1b19afc70883afaa2090b8e6a155da525"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d85e8d048bcb55cedeb52df29ef95bc48344f1c045df57e3276030a0f503c17f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d85e8d048bcb55cedeb52df29ef95bc48344f1c045df57e3276030a0f503c17f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d85e8d048bcb55cedeb52df29ef95bc48344f1c045df57e3276030a0f503c17f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d1662df38386c602dd1bd694b7da036c6e0e75fd3588d62c4a88c123a0dfcfe"
    sha256 cellar: :any,                 x86_64_linux:  "f2d655ca479a5ca81fbd42cb40c622a149cd58767341890f29e6e2033e3b7107"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
