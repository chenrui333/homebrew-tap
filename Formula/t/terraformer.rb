class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/chenrui333/terraformer"
  url "https://github.com/chenrui333/terraformer/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "632c9f20ad41cac960a8be8a21c94834c3e467a2b6bdc18c69659f6d54e4e793"
  license "Apache-2.0"
  head "https://github.com/chenrui333/terraformer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7329a0d0a7179b275335e71e92ba94473d94158d29b5ce885b4a732421a9a1d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7329a0d0a7179b275335e71e92ba94473d94158d29b5ce885b4a732421a9a1d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7329a0d0a7179b275335e71e92ba94473d94158d29b5ce885b4a732421a9a1d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c42af9244be9ab9e27b21ddf32aaf9ff4470a4c129f847409688b12126bbc1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6abe52719130a2ae336526464261afb3ab9e9c3ca577e2359515ed76015ffd5"
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
