class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.17.9.tar.gz"
  sha256 "a8e65e91418332f7dacc2c0f3efa66ada466c5d7fc7e149f878035b7df700e83"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c9ea34413b50d223ad70adeb27551a081f83b8108832249fcb14c9866dc214d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d48e9b9854639f4e82149a4b9f0d0b7dc889f209488d553107cba27e37c580fe"
    sha256 cellar: :any_skip_relocation, ventura:       "b9b8abc4a0beb2cde5b8ff43db54157a2153a0cab75c7a9d829f6e55b4e20d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bba2a1bbf0ceaa1a26107d8306ecabc89cf4d569d4863c8c5515737396a61f64"
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
