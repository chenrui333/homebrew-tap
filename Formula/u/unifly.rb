class Unifly < Formula
  desc "CLI/TUI for UniFi network controller management"
  homepage "https://github.com/hyperb1iss/unifly"
  url "https://github.com/hyperb1iss/unifly/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "7c0742ca5a9b6a8e80ebcd7741acdc86ce23bf3d48eabbc03fd387b25ee4b1b9"
  license "Apache-2.0"
  head "https://github.com/hyperb1iss/unifly.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/unifly")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unifly --version 2>&1")
  end
end
