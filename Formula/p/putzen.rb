class Putzen < Formula
  desc "Clean build and dependency artifacts"
  homepage "https://github.com/sassman/putzen-rs"
  url "https://github.com/sassman/putzen-rs/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "7c402d8e3f33e38ea58986639e55fa1f2968c98365456d087c92599540eb11ee"
  license "GPL-3.0-only"
  head "https://github.com/sassman/putzen-rs.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/putzen --version")
    (testpath/"node_modules/test").write("keep me")
    system bin/"putzen", "--dry-run", "--yes-to-all", testpath
    assert_path_exists testpath/"node_modules/test"
  end
end
