class Reeve < Formula
  desc "Local web development stack manager"
  homepage "https://github.com/yetidevworks/reeve"
  url "https://github.com/yetidevworks/reeve/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "7a595f2419fff0756c62c60b40656a05fd39479cb800fdee4dd2c31c08a060fa"
  license "MIT"
  head "https://github.com/yetidevworks/reeve.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63dbbc586275cb3137a0c6bc52df4ced607d9a65829dc100d99e7535193553ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81297714c0eaaff337db2f5e07bf0b5254b34a2ef87a2f177d84b7a2cd14d571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d8ccd0dab42c0dda3837e61472cef78be3622ca566919145645d7f9fdc8f835"
    sha256 cellar: :any,                 arm64_linux:   "d41e8e4885346d7f9c6e646f68cb8be13b1d1e9da3db8ea0c74067409c9886c8"
    sha256 cellar: :any,                 x86_64_linux:  "45098895419bb2053efb88d37aa6617080c7224a0123882d11c0e187cc607574"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/reeve")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reeve --version")
    assert_match "No PHP versions installed", shell_output("#{bin}/reeve php list")
  end
end
