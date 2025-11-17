class Kanha < Formula
  desc "Web-app pentesting suite written in rust"
  homepage "https://github.com/pwnwriter/kanha"
  url "https://static.crates.io/crates/kanha/kanha-0.1.2.crate"
  sha256 "dea79d04f2c29a742dca69642e473ceca5e458f2a6bf9cfd88847e9124057baa"
  license "MIT"
  head "https://github.com/pwnwriter/kanha.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e5f55e91ad9f5e7a081604ac5e66a47f514e9dd57f54340d2d57354dcd07027"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "432d8d3468284174c4ef49b16777e2a4272da06638aeb2099f750105576e6061"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d9618a0cece521a9fa12cd0401d8ab20a73cfb0fa8dd3709f72496689c19382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1332b8cf0a4353c6b4004461e338812ee4a18516fd7dfc0f9bdbbddc926f37e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d598f21389aaa14cc611c4f1c28cfd3b5a76169787cc6d363bed23e3315fdb7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kanha --version")

    (testpath/"test_urls.txt").write "https://httpbin.org/status/200"

    output = shell_output("#{bin}/kanha status -f #{testpath}/test_urls.txt")
    assert_equal <<~EOS, output
      https://httpbin.org/status/200 [200]
    EOS
  end
end
