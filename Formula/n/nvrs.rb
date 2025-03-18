# framework: clap
class Nvrs < Formula
  desc "Fast new version checker for software releases"
  homepage "https://nvrs.adamperkowski.dev/"
  url "https://github.com/adamperkowski/nvrs/archive/refs/tags/v0.1.8-pre1.tar.gz"
  sha256 "69755473baf5335fbebf46da1f2a8b5ba7b9b3c2495f63d4cb7a15191517149e"
  license "MIT"
  head "https://github.com/adamperkowski/nvrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7356c072b0de41068392423abb90cf7b50e260a73bcae978a840eacf37196b49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4b62ee6401d20826969511d7de18cb743e676b732b12e6dc861c8a8c0137596"
    sha256 cellar: :any_skip_relocation, ventura:       "798f7f6e957343f05fce7ac713c7d9c3d44d89b173174e15e2beee5ff803b28e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c27f8df9625f6cde38d3d920d6ff1ac9d66da88352e034db36f299654a91836"
  end

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
