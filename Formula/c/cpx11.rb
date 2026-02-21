class Cpx11 < Formula
  desc "Modern and fast file copy CLI"
  homepage "https://github.com/11happy/cpx"
  url "https://github.com/11happy/cpx/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "ca13056223142dba089df2698c47e225a1c1e3453ce5e1767d4870404998f9bf"
  license "MIT"
  head "https://github.com/11happy/cpx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "377dbf6213bcfd88f7409fea2b3b2d3feb37e3b06dc4d89bcb39eb2167284c83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db83c16f7b9fee6a5feae0f3908820f9220585004c487092bdd88c5917e1cb39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27998601809d2bff4c48cb77fb6ae561225a388915cd119353af8dcd29e585bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2416ceb976c535464fd3fd59c538a6f5bc2bc9c7eeb22627e0af70be88cdff75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c396d736daed82f08dcf953c6ad82bfec92a2fe6b47d937db8e77687ddd8eca"
  end

  depends_on "rust" => :build

  def install
    if OS.mac?
      inreplace "src/core/mod.rs",
                "pub mod fast_copy;",
                "#[cfg(target_os = \"linux\")]\npub mod fast_copy;"
    end

    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    (testpath/"src.txt").write("copy-me")

    system bin/"cpx", testpath/"src.txt", testpath/"dst.txt"
    assert_path_exists testpath/"dst.txt"
    assert_equal "copy-me", (testpath/"dst.txt").read

    assert_match version.to_s, shell_output("#{bin}/cpx --version")
  end
end
