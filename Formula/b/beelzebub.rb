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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebefd79c01c7d2045fc2ae4987d3fa2ea90f2cf9bfa69fb68cf018055729c002"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "078ee56c6e879cbdb4f14a4977ddbdfab657158011f3b4b3aec5642eb407e028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "837a52bc183b435863df081ad4fcaba1d046364d92484d21e59a1d90923e5f9c"
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
