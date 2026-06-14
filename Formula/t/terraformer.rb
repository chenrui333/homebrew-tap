class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/chenrui333/terraformer"
  url "https://github.com/chenrui333/terraformer/archive/refs/tags/v0.13.14.tar.gz"
  sha256 "6abcf1a54c0b23b0b09139531dd48afda4ce0ae3150aa76f08d9363550393f58"
  license "Apache-2.0"
  head "https://github.com/chenrui333/terraformer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d2a134e13f6705794cd4a237b83f72387c9292d5c3c744d87ce9b69dd48ef87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d2a134e13f6705794cd4a237b83f72387c9292d5c3c744d87ce9b69dd48ef87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d2a134e13f6705794cd4a237b83f72387c9292d5c3c744d87ce9b69dd48ef87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecc7e7540739de29ee8087233388d38be5e1edc51fddad380fc7a36c78893f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "482843fe8a61f63fe65c3d9d8a5a30fefdc58571632bc3d5030fc39f7f786c2c"
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
