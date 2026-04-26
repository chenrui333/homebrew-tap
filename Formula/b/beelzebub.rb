class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.6.10.tar.gz"
  sha256 "9f1d44f34816c4ad9fe135d4273202736d87089e72d47046c18409f5501f86bc"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0013ddbbc960e0d0ce81b48f627f81868da6eb018173f44f58c440e2ae7f778c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7438f087f29811376fcac50efae11360ff707417975bd28ed0733ca59b7ba299"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "342cf331e5764458e681244359a67f002624673236449656c5009de169058b3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21fea2e21bc5ab97bac5c949c400f54d610cc3a373ffe3b2e8d5276b6fafebd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa17e9f476e76e971cd3f66df92640681623882b7035a8b7fa83f9ee83558a12"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin/"beelzebub"} 2>&1", 1)
    assert_match "no services configured", output
  end
end
