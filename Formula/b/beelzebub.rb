class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.6.4.tar.gz"
  sha256 "54857add64b38cdbb773a43ec2668949b610f660d5bd1f5993ffc8bc75f96905"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38f7d2005d0662b82c8e636aad105b997fec6342d3a149604da100d064b7333d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40f712c386be29ef38ec8f194a4527337ad0dcb8928c7324eacd4d1781fdbbf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ea420456a1bd2b9f17d17953d21733700e97f60c6d5bc996cbb7eb1a460eca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4997a425b82aa020263921f2b61a6c88f7866b1876130240a1f3416771b2c919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdfd67bf728234d712d7cbb06a0db745102ae9e41d69de43312ad6bc8c555653"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/beelzebub 2>&1", 1)
    assert_match "Error during ReadConfigurationsCore", output
  end
end
