class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "c354f058c2812e5574e5db0fcc4ed9c1b19afc70883afaa2090b8e6a155da525"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcd3940523d166ca6c9884c988f183bf55542d90ce8780b43bc435484fb62ee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcd3940523d166ca6c9884c988f183bf55542d90ce8780b43bc435484fb62ee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcd3940523d166ca6c9884c988f183bf55542d90ce8780b43bc435484fb62ee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "106521903a2b504841ff8a834c7a3652954d1a0dae12d76900488be76d1c2a98"
    sha256 cellar: :any,                 x86_64_linux:  "fca9836b3b76104c0ca4c450b5f69dae07d8368b8eaef1ae5407d37d05594348"
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
