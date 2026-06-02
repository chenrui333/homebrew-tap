class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "f89ade2bfe1e9ed8c8bef7a082263090b4bf57f69a65afb7950db2667373c9d0"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99d266dfb42997a83305f7560378eabaccfc74a9a578bf977ff0b4df3bb41b28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19be52d137b13f8fa055c503238e6c0a0e7f5cd599d4479fa66859f906394a2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "714e7599147d878d48af45052743f77b3c9b62124dddb225a36fc4359d74c8df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4cd75497e9919ac843057472942c03136b5b6da13dd971a93ea0ff5d706b132"
    sha256 cellar: :any,                 x86_64_linux:  "c074009a315394b097125975cd73c79b371394254b1dc17f4524c2c7db92624b"
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
