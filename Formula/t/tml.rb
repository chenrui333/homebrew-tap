class Tml < Formula
  desc "Tiny markup language for terminal output"
  homepage "https://github.com/liamg/tml"
  url "https://github.com/liamg/tml/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "68a87626aeba0859c39eebfe96d40db2d39615865bfe55e819feda3c7c9e1824"
  license "MIT"
  head "https://github.com/liamg/tml.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f4af8d80c4e057a3344b1e2a84418070b712d86bb636cb2d0358ed0cfa6630c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad4370366634bcd74084ff28104f0c161e1930cc9a55f0639a6d79d5e64d5ad0"
    sha256 cellar: :any_skip_relocation, ventura:       "dac3dbe5f2bb0c07fb780d9d1a11c2789f3d2dceab427f89bfb022cf7c85a659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb9c592e43d2ed799b8271c0d3e865545166d8067af0d33096a7ff0b27776894"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/liamg/tml/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./tml"
  end

  test do
    output = pipe_output("#{bin}/tml", "<green>not red</green>", 0)
    assert_match "\e[0m\e[32mnot red\e[39m\e[0m", output
  end
end
