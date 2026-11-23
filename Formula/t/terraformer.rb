class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/chenrui333/terraformer"
  url "https://github.com/chenrui333/terraformer/archive/refs/tags/v0.13.17.tar.gz"
  sha256 "ca5e610581ddf258fa8a4aa5602072a903444e7a15813bec988a2b1cb82a4ed2"
  license "Apache-2.0"
  head "https://github.com/chenrui333/terraformer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "c062f6f4729ca632df968e46c7a2bd03fcc59b77702d1dae9b832e5e4c221ca2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "269b2b172bcc86772f381735c04e2789b6b927f5b18cc6fc99d6eb997f048ab4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "269b2b172bcc86772f381735c04e2789b6b927f5b18cc6fc99d6eb997f048ab4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc205bc0892faca63d963bdca901b9bb59b75b29c26ec2f8e11296ce0cf02e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ed678114d43fbd658be76b96811a0e6db156f74d039fdf84c7d72e7a04fbe3d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
