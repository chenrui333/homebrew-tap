# framework: clap
class Nvrs < Formula
  desc "Fast new version checker for software releases"
  homepage "https://nvrs.koi.rip/"
  url "https://github.com/koibtw/nvrs/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "67305ede8d833c1c7d449863c904c485ed3cf9ae32b9f976bfaee5108ad244b8"
  license "MIT"
  head "https://github.com/koibtw/nvrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23998dc3d80bc579e28f517d4121c9d38f250c242e9629eb4d6f194e47d07cf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2e1363e21305be81da97c65b45e1b031bde492b3303fcb6c51a08c7d0bbd2ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69779a140205e8d7b3f5c493b26e8c75cc6b7b04ce9e25033a0311ca3291068b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13c51fe4691a3af6c541ab759dbcbc27c89f4703d988341214f0561a871eeae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e73691424c8d674c387b731f154f66e2d69de3cc2ba5606d9e391507fcf1f034"
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

    output = shell_output(bin/"nvrs")
    assert_match "comlink NONE -> 0.1.1", output
  end
end
