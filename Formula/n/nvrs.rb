# framework: clap
class Nvrs < Formula
  desc "Fast new version checker for software releases"
  homepage "https://nvrs.adamperkowski.dev/"
  url "https://github.com/adamperkowski/nvrs/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "a0baea3ae1b5ae5d64f9afc303dc516d19a71b347c7a53729fafee29a559a2e3"
  license "MIT"
  head "https://github.com/adamperkowski/nvrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4ecb0081a00287e6884a68daea77e467477e36f1dbc4a8532472ac829e19634"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6182b6d0fb0bb39e3223a824a40661b92f8cb488d59c85e8443c6b584f27054c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cbb735543eb275fe8dfb3f348b3a8193a05ac92868abd579f1f546036c379ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afb38caae99786c66854fcd215f113a73aadafac6caba7eb390b31f9a3af3ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e2bdd8710e1ea5298ccc7ede5760b4726c21f19719f32baffc6dc88fc8ebae5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "cli", *std_cargo_args

    pkgshare.install "nvrs.toml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nvrs --version")

    cp pkgshare/"nvrs.toml", testpath

    (testpath/"n_keyfile.toml").write <<~EOS
      keys = ["dummy_value"]
    EOS

    output = shell_output("#{bin}/nvrs")
    assert_match "comlink NONE -> 0.1.1", output
  end
end
