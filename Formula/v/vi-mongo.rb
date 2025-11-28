class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.1.31.tar.gz"
  sha256 "51520c5230f96eacd0673a382e8f2498bcea90d47474f7c2fe78720bda7e20ee"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c58a3d62502c383799f8048409ad0a3aae691ef18321d9a742f22d151e1ae33d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c58a3d62502c383799f8048409ad0a3aae691ef18321d9a742f22d151e1ae33d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c58a3d62502c383799f8048409ad0a3aae691ef18321d9a742f22d151e1ae33d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad4bf855f834b331e0baa80fb4b2f918c53ed07af41e724cde53d1c85ac74a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a6d16d1a62b7f7f9d93d50cf87cd5216d9ae3aba252ac5cc01c869a1d5775f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kopecmaciej/vi-mongo/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vi-mongo --version")
    assert_match "No connections available", shell_output("#{bin}/vi-mongo --connection-list")
  end
end
