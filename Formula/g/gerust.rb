class Gerust < Formula
  desc "Project generator for Rust backend projects"
  homepage "https://gerust.rs/"
  url "https://github.com/mainmatter/gerust/archive/refs/tags/0.0.3.tar.gz"
  sha256 "a6ed76805d5f8d2212761eab18623d35dad12276a72dcc51e8860132b9923ca9"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gerust --version")

    (testpath/"brewtest").mkpath
    output = shell_output("#{bin}/gerust brewtest --minimal 2>&1")
    assert_match "Could not generate project!", output
  end
end
