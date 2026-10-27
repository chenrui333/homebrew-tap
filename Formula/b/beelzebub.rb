class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "7f04e3b2f02d04c72cc347af2cf543cebc3d6f3efc5be0786c7e5444abe04022"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b347d8367ea3fc2f64e8b3dd34a325c2d03255b6e6a2b757cc6b755768059c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac92a36d3446fe2d04c41cc537ddbe49d4c3987194f4d270d04729d50de6f514"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f2eaebb5bf40b1d27f10dd0f900e1c1d5595793ac057fa682a8db7182060188"
    sha256 cellar: :any,                 x86_64_linux:  "3c5e72c5b3b53484a23033ea22ef793c21248e09b68c4d5a08760c135615c797"
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
