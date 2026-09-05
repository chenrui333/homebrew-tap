class Seednaut < Formula
  desc "Inspect and extract Seedvault backups"
  homepage "https://github.com/Baltram/seednaut"
  url "https://github.com/Baltram/seednaut/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "ee840d495e46b4e24a8f1778df7be18e55c1a493b334c03fdd3d1729bcca818b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Baltram/seednaut.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seednaut --version")
    output = shell_output("#{bin}/seednaut list #{testpath}/missing 2>&1", 1)
    assert_match "The specified input path does not exist", output
  end
end
