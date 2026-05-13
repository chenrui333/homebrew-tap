class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "b643324f5360ab768d0738e5f699ae75cdfb22c46cd624b69647ac33a9984acc"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03889533b46ef3f289cb0d3ce7b8f07a6164ad1c7d063135aa9962975fdb3c70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03889533b46ef3f289cb0d3ce7b8f07a6164ad1c7d063135aa9962975fdb3c70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03889533b46ef3f289cb0d3ce7b8f07a6164ad1c7d063135aa9962975fdb3c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a4f7cbb78a67e47aae84258a7d52529c9f537515210459322ede60169e1338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac9c022a63bd8fe32cc9180de0f6aeac6294238cebfadd284d164d87c9a8c305"
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
