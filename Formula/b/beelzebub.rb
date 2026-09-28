class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.9.2.tar.gz"
  sha256 "a31ed8718258b0642b98ed88db780fab5b3e048f9bac2500cd2bdb8b969660fc"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32325111d703cf9268a4b92d558b21ef5baa8b1e4c3894f490cad02904b12d3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7bae455d5e1dbc0ea2dac17a28f10a401d647c3416f5c0f113afa35f8126c57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15f36b26a74b07f58d9a96cbc3314d0d81806877b2aad7d73f162f9d5d1dba81"
    sha256 cellar: :any,                 x86_64_linux:  "3f456d429ff14590e76460093353514c5b39d05a1a6f5758269cb8809e877097"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin/"beelzebub"} validate 2>&1")
    assert_match "0 errors, 0 warnings", output
  end
end
