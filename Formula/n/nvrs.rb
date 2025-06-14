# framework: clap
class Nvrs < Formula
  desc "Fast new version checker for software releases"
  homepage "https://nvrs.adamperkowski.dev/"
  url "https://github.com/adamperkowski/nvrs/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "d306d520d76d84826e267c1baa58e497b9f14d7bd1d9b651f07e7f598dd7821d"
  license "MIT"
  head "https://github.com/adamperkowski/nvrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daacf2cfd392ab82447b4cf05f0b318b7883972a98cca9a7c66aadbd33343d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4ff8b2e72815fe31f4846b66cba35fb91d3e03155e338f2226bdd815ca552f9"
    sha256 cellar: :any_skip_relocation, ventura:       "941d32e6e637cc8fdcd4138f1c96dbddf615f4e6686f4bf42ddf5dcad9eee3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d52078498f791381ea38015a5db824c3c5309b6882923b65a89519ad02096091"
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
