class Hygg < Formula
  desc "Simplifying the way you read"
  homepage "https://github.com/kruserr/hygg"
  url "https://github.com/kruserr/hygg/archive/refs/tags/0.1.17.tar.gz"
  sha256 "f657312f7071300561d8e73c382b7ff2350f389355ff55db0053fb4584062f85"
  license "AGPL-3.0-only"
  head "https://github.com/kruserr/hygg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a216872df67892945901b17fdeb8714a75a0b5939c37899388e12731723089a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda804d388f9c3804d690d2cc182eacefd89f22db6c22c4ec2d9b9dc3d14cf0e"
    sha256 cellar: :any_skip_relocation, ventura:       "d62e6b8bcdef00100a5b61e651fad3ad9f9be276f572c25194ac572973ef12fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08e7cdbbe0a31e583e287524cfa4972037f88c7e6e5cf42df03a0e2d95bbbd71"
  end

  depends_on "rust" => :build
  depends_on "ocrmypdf"

  def install
    system "cargo", "install", *std_cargo_args(path: "hygg")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hygg --version")
    assert_match "Available demos", shell_output("#{bin}/hygg --list-demos")
  end
end
