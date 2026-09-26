class Cpx11 < Formula
  desc "Modern and fast file copy CLI"
  homepage "https://github.com/11happy/cpx"
  url "https://github.com/11happy/cpx/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "3f2aa3a4ef8ab86239671eeadded9b9b2f942ab448842e2170e63f870ee5c2d0"
  license "MIT"
  head "https://github.com/11happy/cpx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "321a183929019635795c7b3a2763fb108add38794990dc48b0d51a3ef911ce69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca8d6458ffd8c9cadd85ae3b04ad5dbc4911c72065c64bb836bb2b2b9b2dc325"
    sha256 cellar: :any,                 arm64_linux:   "8d7569115d39e8e14c24e8674d449358f0be9f77624a6ca04aa5afaa5d961441"
    sha256 cellar: :any,                 x86_64_linux:  "2e2b44e24257d8395a8ba4ec71253baa436a5384c05def641bad4bb5b6c7b320"
  end

  depends_on "rust" => :build

  def install
    if OS.mac?
      inreplace "src/core/mod.rs",
                "pub mod fast_copy;",
                "#[cfg(target_os = \"linux\")]\npub mod fast_copy;"
    end

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpx --version")

    (testpath/"src.txt").write("copy-me")
    system bin/"cpx", testpath/"src.txt", testpath/"dst.txt"
    assert_path_exists testpath/"dst.txt"
    assert_equal "copy-me", (testpath/"dst.txt").read
  end
end
