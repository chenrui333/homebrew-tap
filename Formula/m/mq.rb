class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "bd1e63bdbb1f6923002158ea01f785f4ff277e2d2e22b82f79cd9e12bb3fa662"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fe3983b513d20cfdaa9448fb4f2ff385527e25650bc7a1a3bb32488cb8d04f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a882d33229948fd6b61c45a1697fa3b9f1923100bc74a926093f03631eef28b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77011bd9efe0eba31bd4ec34407c0b566c8d40603cd7ad6caaf39a3dda0158f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c30a4bba0f7e7c958c0eb01fa1ec9296b329f40a9e8444dcf167b0b3cef24ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be8f36307f0e5c3b4ffcba8d1f7627303c8c1e42b850ef45bbb0eddab3711924"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
