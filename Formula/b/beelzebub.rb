class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "f89ade2bfe1e9ed8c8bef7a082263090b4bf57f69a65afb7950db2667373c9d0"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5467e6f7a0d14b4d114715ab1aab8cb83ce77af2415b1bfeb0e51b84c18ba06f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1698ae23ef1d897adde28f443ae2ad35f180062b2dc6b53d0cbb7ef0d9e5aa32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8feb3d21ff2a9a347d195e2aa70b96dd317c82373099f0898d4b17b73df625fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d65ee4882e19d04ed8e2f34480caec5008cfc8d5d415569ba8c8e4a9f5bde493"
    sha256 cellar: :any,                 x86_64_linux:  "6aad84720f25e32ea166a6029a85cf580401fb10d65316f60f4c677a5de93d14"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin/"beelzebub"} validate 2>&1")
    assert_match "0 errors, 0 warnings", output
  end
end
