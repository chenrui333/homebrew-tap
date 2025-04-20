class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "69a7ac90d488351e8b675bff4091a9cb385211e1fa3621c3f706a1260c7d8b27"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a47c16d03c3bb04410a6bae696341f2497622bfb91df6e0479dd8d773bdb0e93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "712e2675b738adbbe0cb401ded07708cfc1c97e32b7860e049060f1d0a0e5f47"
    sha256 cellar: :any_skip_relocation, ventura:       "0b5620e6e00ce87d8b41df7ed9ed5b13e718c3ffe8eda0dd91a57c6c8aab77e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a71ad39afde495b1e54cf2ba1941244ec28b191c5cb36dda8c83f92af9ca096"
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
