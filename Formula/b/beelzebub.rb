class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.6.4.tar.gz"
  sha256 "54857add64b38cdbb773a43ec2668949b610f660d5bd1f5993ffc8bc75f96905"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c6e7167a21088d7b15cea005ebcaf8111a5b2c6c14af0b913251e6026eba1f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f73a3ebb4230c2b74dcbdd92c6f2cd4a29964ba09a125fa54e78efa62a59092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94d6fdba6a88394168a9d8a0dd883f14d98dcf22e8725e1c1d4db8720ca1c96d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dca0241a548515ea08a8a7cf368c9de10acde1eda0bdd709d8512cb398784dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90526477456c756858c84e1d2f72a27bd3a425bb70103d40166ad1d12d6a4168"
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
