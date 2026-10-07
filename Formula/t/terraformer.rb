class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/chenrui333/terraformer"
  url "https://github.com/chenrui333/terraformer/archive/refs/tags/v0.13.16.tar.gz"
  sha256 "01e6bf0bae5b141acd0200380901563c9d89023c17e1b51338738b4dae655c4f"
  license "Apache-2.0"
  head "https://github.com/chenrui333/terraformer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6965cc6cc71eae8a9135fdc4d2b6f97db7c39ecd46ace9a7b79f7f69eb2f1934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6965cc6cc71eae8a9135fdc4d2b6f97db7c39ecd46ace9a7b79f7f69eb2f1934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27d8923a2347ea546fe5dd0bfff1772c5bd9a93af3671e4927ed1a8f2c22aa97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ca0c87aae1c873691e797453536fbfab1255406602867b907275d345d3b5cbd"
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
