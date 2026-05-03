class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "ae1b1c5b336715dbd995d2124f445954dfd43e505f2e2c3895ca30b203892465"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7d0becf958e71faaf117823cd26c0f3b06a358bb1d24e71af8f8cbe167eaafc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be643f68cc463c8ce40cfa4f964b101957035a02291c54018974d79fc0a010f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3978584b787c744613da6acdc7abc297e5ca0279c676ebe7ad8a891df5d32d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf7a6b2985abbecf11129d4720842b3f21d8c3be13ec338bf93f6b79c28ab42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "966695d1818dafd1597e5516c491a17df1e849793ad3ccc9eeaa1fadf4a084e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin/"beelzebub"} validate 2>&1")
    assert_match "All configurations are valid.", output
  end
end
