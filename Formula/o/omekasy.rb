# framework: clap
class Omekasy < Formula
  desc "Converts alphanumeric characters in your input to various styles defined in Unicode"
  homepage "https://github.com/ikanago/omekasy"
  url "https://github.com/ikanago/omekasy/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "c887cf7c35dd2f82df823e1e74cde496967e0ff3bfecb4b87560fb4fb18d36f9"
  license "MIT"
  head "https://github.com/ikanago/omekasy.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omekasy --version")
    output = shell_output("#{bin}/omekasy -f monospace Hello")
    assert_match "𝙷𝚎𝚕𝚕𝚘", output
  end
end
