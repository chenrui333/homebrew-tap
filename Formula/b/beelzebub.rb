class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "1ed26f12ff26a73272b24a984be3df443392c2daa7deb87e4810d9a35575c147"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7828ec3fb11b1f7ff5bafbcee6c2e1eefb8fb4aa881f46916ee8a301ea51d61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b29dc164e13f99e815f55666c2e65737a2dff7b2fa52fe1bc0fa9e3611af68e"
    sha256 cellar: :any_skip_relocation, ventura:       "3fa1a26b0e27f3430fc06a2b2780dc24906950ce61016667d1602a84194f1da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45f47972f0aceb4f4096e79233411dbd9251eadd9ea7524cc4eda0be90e623ce"
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
