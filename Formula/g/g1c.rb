class G1c < Formula
  desc "TUI for managing Google Cloud instances, inspired by k9s and e1s"
  homepage "https://github.com/nlamirault/g1c"
  url "https://github.com/nlamirault/g1c/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7017b860ca983a18aa29098256542bacb2f174ee4e8c10f5127440094d657a97"
  license "Apache-2.0"
  head "https://github.com/nlamirault/g1c.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83e3e8e7b18683ea019f745cc8ec2ee58d048b80dce9015864b16a13772ca4fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56fef57c840df090da8def99f9e2694d4070e887f65408c91a81cc9d8d8fe278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48589a8738d5643c1bf28c49093662f5331d49c16c290eb74e7eff40406307ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10640ea46602d50109904d8071e6893656bd9fc935dafb1cd4a4879a1b6f3f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "201257cf23d343981560bf91c5dc95d4c3545ef485fa13d2940a8e8e5279384d"
  end

  depends_on "rust" => :build

  def install
    inreplace "Cargo.toml", "0.1.0", version.to_s
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/g1c --version")
  end
end
