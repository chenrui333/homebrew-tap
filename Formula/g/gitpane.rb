class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "69a3ff96e488d0fb55336e0de3a5d6de63f0aa9ab05cab2561e7ab48ac7e3647"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitpane --version 2>&1")
  end
end
