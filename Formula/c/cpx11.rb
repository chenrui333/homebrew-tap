class Cpx11 < Formula
  desc "Modern and fast file copy CLI"
  homepage "https://github.com/11happy/cpx"
  url "https://github.com/11happy/cpx/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "ca13056223142dba089df2698c47e225a1c1e3453ce5e1767d4870404998f9bf"
  license "MIT"
  head "https://github.com/11happy/cpx.git", branch: "main"

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
