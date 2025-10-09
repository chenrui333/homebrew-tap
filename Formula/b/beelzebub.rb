class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "626acdc6b814d9379f7564db88601a10b803723f237fd849d4ca626f7989b704"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c02094232e8378f099f6321daa387fd4f9fd10169ea7d2468177d50a269e53d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "851975453ffa09eb0a0ee3f9a02357d78af5604f92d56613e6b2e81c5af469a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b0fed5eaec4ad2740c9684587c5bfad11825da713b8b03fa74de834fc5c94bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfc2dde9f122e6e757158e5250c1cf3bbcf8d3d21ae5b02ed426565720e8a09a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eb9bae3508f38e4c0ed3deb7151961cb69ffb2f37cb48e363b5f666beb78663"
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
