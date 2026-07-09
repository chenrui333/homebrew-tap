class Dotr < Formula
  desc "Dotfiles manager that is as dear as a daughter"
  homepage "https://github.com/uroybd/DotR"
  url "https://github.com/uroybd/DotR/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "87b0c8a5c948ae2bf7a8d24546a19a326663c0692cd08cdac038584c68eaef91"
  license "MIT"
  head "https://github.com/uroybd/DotR.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00abb712e83e574be66fb2eefb3d45ea166a72a2fbe6aa61db82cf168bcbb208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bd7ad04c5e04ba7bfd6e6f7aa102d49c0ef671a300414d32bb00edd262e3526"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b6f2e0382efc462f558d950f10ebe9bad1f726f187514a0df4186f529526526"
    sha256 cellar: :any,                 arm64_linux:   "91efdcb94a0f3bc17eb5d74af86a000a05e0cb22d5c66c319421cf7a5a9eb230"
    sha256 cellar: :any,                 x86_64_linux:  "2acbd33a8dd8eaf36892b50d6bb34dc10b0db7d8cc11dc73cef5d791be9d15ad"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotr --version")

    system bin/"dotr", "init"
    assert_path_exists testpath/"config.toml"
    assert_path_exists testpath/".gitignore"
  end
end
