class Pphack < Formula
  desc "Client-Side Prototype Pollution Scanner"
  homepage "https://github.com/edoardottt/pphack"
  url "https://github.com/edoardottt/pphack/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1e7006f6834da2a511a2b375aa7c56d0559afea30fcc4bc63a7d5237aadfb30f"
  license "MIT"
  head "https://github.com/edoardottt/pphack.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a1ee0c35d2d86cc22bc9e7285372998a025ca10c41fde9cf4d2bfd2e559d29b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "513965d438e36c82848c4fcf1c9dd7a9274f2856d34760f4011d65eca90595ad"
    sha256 cellar: :any_skip_relocation, ventura:       "c7b802811f6861b02f66c75a4c393e8fc935dadad2fcdae8cfe501b1fb8b7e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ba867feff32e93c2984c437d361b05447abe3caccda7fe48cf440bf46c3ff7d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pphack"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pphack -help")
    # output = shell_output("#{bin}/pphack -u https://edoardottt.github.io/pphack-test/")
    # assert_match "[VULN]", output
  end
end
