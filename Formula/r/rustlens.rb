class Rustlens < Formula
  desc "Blazing-fast Rust code inspector for the terminal"
  homepage "https://github.com/yashksaini-coder/Rustlens"
  url "https://github.com/yashksaini-coder/Rustlens/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "3c5729600ad797b1e9e69cae57ba3b60a617bec3f30c27c975ef9d32b70052e1"
  license "MIT"
  head "https://github.com/yashksaini-coder/Rustlens.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34aed5afde476e0002b058bc5b0c45f7a93cc8b096918f09018907ffc790c0ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e143879f105d4823091ab7fa0d3745f2d996947dd7924d942005ec98c9d09cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62385b001a81ae3088b37a5b39d4bf977f7d37c3fdd3f8b635bdd331cd802ae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc3b3e46876330c3561a55077296cb7ba2f0e9c6c71e2d752b2d63fac7a950ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "325cb04d59c8edfdb9788da3e8e926f516aa4d5bb7260ccef786c08e3e9c38af"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_path_exists bin/"rustlens"
  end
end
