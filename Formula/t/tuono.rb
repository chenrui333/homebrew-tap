class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.17.7.tar.gz"
  sha256 "0ed9ae530d3ae93dd88f3b8c4be9c3b160b854dc6c0bc9caffac35e43717c3cd"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

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
