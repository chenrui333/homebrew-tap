class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.6.8.tar.gz"
  sha256 "7af9cf5e9f67477a5d6996c8579c2334d8921c817bdcbebd9f45a63e85dc3a7b"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08e5d7d29424fff677ed802ff147c4574a8c5fb55a94d26551b79cd457eee4bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf26697cf8d8300fb10da1c2f277fcc960d7da49343da60e5ebb517c761ffbc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1705a40e4eb74a3ecc21925f1ab2bf038048724e758c8903b688f0ab1247a83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6521d72da0602af4137e2f4ebf87b777ace416e112f96db22c29df0a9e3d3fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71e98594cd8430169bdc1a924d362640fc502741760486701fc0b4aa4fc56385"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin/"beelzebub"} 2>&1", 1)
    assert_match "no services configured", output
  end
end
