class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "1411433709837af82873f020b7a586dc5dd65eae671301d3fdf1b076898975bd"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d30c8eea3420ccdbf7a92bcb1513d9bba2114700a2ff087f33744870fd804d14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d30c8eea3420ccdbf7a92bcb1513d9bba2114700a2ff087f33744870fd804d14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d30c8eea3420ccdbf7a92bcb1513d9bba2114700a2ff087f33744870fd804d14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "214932a4f2b1516eb7667a261d8900ade192ccdacacc08cd8b19cc446f11f1b2"
    sha256 cellar: :any,                 x86_64_linux:  "7481635022f5672ef3b74d99de42469754160a74b49974d80c326c2d3e53930d"
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
