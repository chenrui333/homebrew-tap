class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/chenrui333/terraformer"
  url "https://github.com/chenrui333/terraformer/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "632c9f20ad41cac960a8be8a21c94834c3e467a2b6bdc18c69659f6d54e4e793"
  license "Apache-2.0"
  head "https://github.com/chenrui333/terraformer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42057c077790d3a4227c9be6fbd297cba6689511d38427d97d411f7bb9ef0e4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42057c077790d3a4227c9be6fbd297cba6689511d38427d97d411f7bb9ef0e4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42057c077790d3a4227c9be6fbd297cba6689511d38427d97d411f7bb9ef0e4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "265a466988edad47aca43229cd92a37b13e3011dbb3f032ffabf3c860791e056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "646bda84e02406095902aae4ba61c48c4b59ad0cd297c3f8cb99c7afc7fb5897"
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
