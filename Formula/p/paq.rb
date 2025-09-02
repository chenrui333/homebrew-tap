class Paq < Formula
  desc "Fast Hashing of File or Directory"
  homepage "https://github.com/gregl83/paq"
  url "https://github.com/gregl83/paq/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "8c1bb3d59e3346551d81b07818adf62dcc12d0373295ac004360cf977522ce19"
  license "MIT"
  head "https://github.com/gregl83/paq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dfdd922f8d83f986b377cb8b08eeb5c9605f5ad2fd978f5ea447c7a55d779f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7349a612ed55f3a217856fc53793afbfd5b91df6af59a80245407a7d775a7ac"
    sha256 cellar: :any_skip_relocation, ventura:       "1a80ed13cada3f3f958b1b6a730dc9381bb34ad32ff4163645c93fb85ecfe819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fae5a99c1d6f437365ef8eecb9e473ca12ba855abf7d620300ab517997f47933"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paq --version")

    (testpath/"test/test.txt").write("Hello, Homebrew!")
    output = shell_output("#{bin}/paq ./test")
    assert_match "eb9122ffff587d1cb9e56682d68a637e8efaa6c0cd3db5d90da542d1ce0bd2c2", output
  end
end
