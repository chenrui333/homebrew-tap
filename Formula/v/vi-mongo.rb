class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "f22fb09b6f5d8439663142dcc02039b788c59aa9ffdeb32a96c2e2dddc360ffe"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad06addbb6fefc6074f3f43c828ed1e0f611f85670b9205bbe1c847e1732e150"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad06addbb6fefc6074f3f43c828ed1e0f611f85670b9205bbe1c847e1732e150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad06addbb6fefc6074f3f43c828ed1e0f611f85670b9205bbe1c847e1732e150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffdd02f8c61d917ac071d0623acf95f151a1421ca585decd4af5db3daff5a4af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1239b55a7d592e6187500e2c425853a3f2520840153e19c2602c64c7de91ab30"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kopecmaciej/vi-mongo/internal/build.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"vi-mongo"} --version")

    output = shell_output("#{bin/"vi-mongo"} --connection-list")
    assert_match "connection", output.downcase
  end
end
