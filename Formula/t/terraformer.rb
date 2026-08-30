class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/chenrui333/terraformer"
  url "https://github.com/chenrui333/terraformer/archive/refs/tags/v0.13.16.tar.gz"
  sha256 "01e6bf0bae5b141acd0200380901563c9d89023c17e1b51338738b4dae655c4f"
  license "Apache-2.0"
  head "https://github.com/chenrui333/terraformer.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "083bc7afa627889f6ffd63fdf3355fe3d7d99a8f13314b887a66701be808c9f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "083bc7afa627889f6ffd63fdf3355fe3d7d99a8f13314b887a66701be808c9f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "083bc7afa627889f6ffd63fdf3355fe3d7d99a8f13314b887a66701be808c9f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd1ad84a86bded77c0f1bec0f155d12fc5bf94fda308ecc9820a162ac4bdf8e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d546d3505b3562b67d52ccaa1ae4871662aa2806d78ac6a4a5c2b816036ddf0"
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
