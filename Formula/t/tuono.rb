class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.17.8.tar.gz"
  sha256 "93d17fc4f9324d6a3c2da45f655750bf47da8a60bee3a49b0f152d4b55289935"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7777259a258de97caf993afb7a91a2053dffcc3e84a77d90f8f1b6590b4ed1f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4b2a32dc9875a02575476f2e88660d480a28b87495f39561194b77caade4876"
    sha256 cellar: :any_skip_relocation, ventura:       "e894c01e90dd89375b40dd859722b0d73459ab568faf4730c46a896f3900e3e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f0c8ed33f9ff3d9bbd1ffb4b85e35ef61315720dc799449b8517156d6a6de1a"
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
