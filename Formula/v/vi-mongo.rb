class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "298b6553a576716086def2828588552cfd11c4ca783b53b5c35659c5e73fb06c"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "324d0f865417520a941ec49331d95f8b74d586276355a39b8a7539fa569c7ca1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "324d0f865417520a941ec49331d95f8b74d586276355a39b8a7539fa569c7ca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "324d0f865417520a941ec49331d95f8b74d586276355a39b8a7539fa569c7ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b881078a4d018d3b35c4e5df47be647eeff30931be71036fce3dccfebf188778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "316712664d81ccdd0fcd6abbbdf2afc406360df36c3aea866a195abf8cefa011"
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
