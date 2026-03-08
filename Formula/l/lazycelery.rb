class Lazycelery < Formula
  desc "High-performance TUI for Docker container management"
  homepage "https://github.com/fguedes90/lazycelery"
  url "https://github.com/Fguedes90/lazycelery/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "5e9ec7fa7285678eb07fdf88cd9147fb6ed0ec1e77df6f1204661e2275114966"
  license "MIT"
  head "https://github.com/Fguedes90/lazycelery.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5edd804874a42a0cfff589aaaf2932543f8952a81b423adf4249fbf0b05b80a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b143851d6d13d9df60716a938559f3c940c12bd6f884ce65d85ecd43977f0310"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "197a73f993a3305e056f7dd413661142495bd2d714375d97d02022e5f5eaf9f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a01c9cf37c38bee11f8c29ec49cf18fc98869ceb62489b4990e6ef32e5821d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc413b1dbc4a7247c1c90272a2d62058124451555ae7b9b7a3337a034344e84e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazycelery --version")
    assert_match "No configuration found.", shell_output("#{bin}/lazycelery config 2>&1")
  end
end
