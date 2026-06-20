class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "a6c5943802f25b75008c909c95c87175a48c40ebaab089326fb8bc72bacd0824"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "575a6bc2e921cf1402aef846f5273c0b571bd87975c1d962fe831b01aeb07295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "575a6bc2e921cf1402aef846f5273c0b571bd87975c1d962fe831b01aeb07295"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "575a6bc2e921cf1402aef846f5273c0b571bd87975c1d962fe831b01aeb07295"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cdbf844e075a5dab38e73e7f5a436de157d2f0d0dbd14bc980cb0a1a693c703"
    sha256 cellar: :any,                 x86_64_linux:  "d760a96ba3f0c928efeaa3227cdccf0d04edb678e0ab3922a73a31759c91c69e"
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
