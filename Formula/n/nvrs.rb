# framework: clap
class Nvrs < Formula
  desc "Fast new version checker for software releases"
  homepage "https://nvrs.adamperkowski.dev/"
  url "https://github.com/adamperkowski/nvrs/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "96fe66043969a8fd2c1e51055b80d1b228bb9b9d057ecce3e2cbd034bfade6d2"
  license "MIT"
  head "https://github.com/adamperkowski/nvrs.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "nvrs_cli", *std_cargo_args

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
