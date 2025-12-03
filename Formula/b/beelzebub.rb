class Beelzebub < Formula
  desc "Secure low code honeypot framework, leveraging AI for System Virtualization"
  homepage "https://beelzebub-honeypot.com/"
  url "https://github.com/mariocandela/beelzebub/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "c2ef5145c52229b4955b7d4603d268c7d878184f96bba32e4efe6c4e0379cdd3"
  license "GPL-3.0-only"
  head "https://github.com/mariocandela/beelzebub.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b358103615c19829174362d4ec9274c1459898e43950a6e6052898a5eee8f146"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc4108a23385c3b3a540668112d8bf1880cb74f5807edc073f56e367d20b0f6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a03b6e23fad890a4eba9b9bf79c8f8c1e98dd32e471f1428b380c494f2b699f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5a074593d3d29db12da0808cfb2126c19c8720be83c573990f1b75958a8938b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "674fea818e7d6b9db19528df724f082fdf5dd70c88f95db4af44e99cebadeb67"
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
