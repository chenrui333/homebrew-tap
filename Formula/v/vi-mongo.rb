class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "924c585451d5f9ec590d46fa5ba706e9e3ea3b2732ecec0b25a46dfc4939c8c0"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d4da792e8a042389ec54578aecc448aa4be8ca4ded33017e50c181850aa6ec2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d4da792e8a042389ec54578aecc448aa4be8ca4ded33017e50c181850aa6ec2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fede0e151a5ac2b373f60e981a67d14e0b047d163d952d5f7b1fa140d4e86c7b"
    sha256 cellar: :any,                 x86_64_linux:  "917bedf90e3d66e987f61580bc523d7d284e8d522d0bc4075b88aa610c337f1d"
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
