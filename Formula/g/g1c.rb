class G1c < Formula
  desc "TUI for managing Google Cloud instances, inspired by k9s and e1s"
  homepage "https://github.com/nlamirault/g1c"
  url "https://github.com/nlamirault/g1c/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7017b860ca983a18aa29098256542bacb2f174ee4e8c10f5127440094d657a97"
  license "Apache-2.0"
  head "https://github.com/nlamirault/g1c.git", branch: "main"

  depends_on "rust" => :build

  def install
    inreplace "Cargo.toml", "0.1.0", version.to_s
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/g1c --version")
  end
end
