class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "cc682594d1045093a04088a32c48dcd7cb57dfc731262b98d5bce7aeaa8320ef"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e97be9453cbc55721f54d1a855c2877259a1e3ce925b42ceeca7f41e77055f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99a801b829224feb7e9d6f05fb908de1d11f3ce0710820a7587829aa55cc716e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49a72f28090ebfec343cd64e39e50327f74c86a967a7d98906c0beb8ebffc4c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61007cd0778ba902d7fa53d8b027e1559acbab0d5036aaca95147236c12f85cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71afea231e459e9e8004bf1114c2ecc4614b20c687cf9f90fbd958d469cc20a0"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/beelzebub 2>&1", 1)
    assert_match "Error during ReadConfigurationsCore", output
  end
end
