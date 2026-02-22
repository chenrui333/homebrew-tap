class Cpx11 < Formula
  desc "Modern and fast file copy CLI"
  homepage "https://github.com/11happy/cpx"
  url "https://github.com/11happy/cpx/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "f7d8b7d1926c007d358780dbf82e4ef6b0a84cb44ea3f68732f29a83e78a0495"
  license "MIT"
  head "https://github.com/11happy/cpx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3691cf66bbfa80cdf2d1ec8b42ed740fc29d32823248a5c3a8dfdf2fe6e60283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ae59317da956e0900ecdc682006d658acc7984b399f7fd7e3b6d5ff1d014fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "846b3a4f582dc2ad868f41658fa55958e2dde830a38e029d0b7cfa38c9fd4fe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9643e173b0163e8efee05a4970a162531affeb132d909cd7de572595402a465c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2b9b1eba96ad8ef03274c5c78a72c1f679613dfc97b26bff95f3fb5a618a987"
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
    (testpath/"src.txt").write("copy-me")

    system bin/"cpx", testpath/"src.txt", testpath/"dst.txt"
    assert_path_exists testpath/"dst.txt"
    assert_equal "copy-me", (testpath/"dst.txt").read

    assert_match version.to_s, shell_output("#{bin}/cpx --version")
  end
end
