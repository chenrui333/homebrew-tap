class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "58ed006b28f3afa0fe3d12fb3e803f3136b480c87b82e7f007e28f56479602a9"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ad2b115f5f82affe5c1ce1b5471834b4edb2c3adf7ee0c5405beb7780f92df2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1501f6a1fee85c7abc0fa9a350c262170a08ebd810ea192885a0ca53617875f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7866333c562493b984daa4a09e75788eeda4b373290d20fb9d88ba022615471b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16b7e98a49f7c4ace73c4bf58609f6004a2af6264e08b5ddacd42d839c63f906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "431e74f00313d4dbcdb9b92d68603ce2018057ae8e365b841d7a9831d8eedebc"
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
