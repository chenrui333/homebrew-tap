class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.19.7.tar.gz"
  sha256 "e74a90396d220302a55b378913467f09b717f5157e12201d0da3d120cfcde08b"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daabc18bbac5fee80ff44d9bc600efba12c9874a880edbf9283700bf8c2af2dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c0cf10ae0c6bc09f8d4276f2e81b9537549cf4a1f68f56da5bdfec7155a4135"
    sha256 cellar: :any_skip_relocation, ventura:       "35d5404cf73c1a07cfbf04215c0e332326035759a5157b877fc6d4176ceaeda7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49c05ae71e40f68ff2129f8606bf00edf43879c3d3764dcab0b19b611630a2d9"
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
