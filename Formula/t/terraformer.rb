class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/chenrui333/terraformer"
  url "https://github.com/chenrui333/terraformer/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "6bd59c43c8ffde6b62c1d788c99fb37e41e7b62e2ab8b00f375a7c52c2d38d62"
  license "Apache-2.0"
  head "https://github.com/chenrui333/terraformer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d29dc90f7ba61bc4343299198ec28c5bb7c04af3e58b35eb45b261743c25b61b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d29dc90f7ba61bc4343299198ec28c5bb7c04af3e58b35eb45b261743c25b61b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d29dc90f7ba61bc4343299198ec28c5bb7c04af3e58b35eb45b261743c25b61b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e03eac119ea7690231219ee7a0e069ce2dfa89aa916bcd1e25d8a0db93e5ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa90dff5e37df721adc48035d90ca6bdcc02f61185f76b2162d694fe19063e1f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/chenrui333/terraformer/version.Version=#{version}
      -X github.com/chenrui333/terraformer/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraformer version")
  end
end
