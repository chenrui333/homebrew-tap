class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "b4a3acf21bcc1d066b46f0f4bb38ad1d328ae153d3e5760b0c57d369090275d2"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f87fc3ab716f1538d10899073ecd5663a831d103ce47d260e3727f56a6d96068"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d834de58173c672f1b77a7a91c491d1107540608de68f17a4edb5bf85604b170"
    sha256 cellar: :any_skip_relocation, ventura:       "53254ba9e14a67792f38c677d45281c597390a4707beec7c62195a220bd4ac8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b40728bdcb6fca96a06b531fc70b3107329aac25cb51a347bfe83d32294d127"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tuono")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuono --version")

    system bin/"tuono", "new", "my-app"
    assert_path_exists testpath/"my-app/package.json"
  end
end
