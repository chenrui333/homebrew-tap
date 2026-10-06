# framework: urfave/cli
class Sato < Formula
  desc "Tool to convert ARM or CFN into Terraform"
  homepage "https://github.com/JamesWoolfenden/sato"
  url "https://github.com/JamesWoolfenden/sato/archive/refs/tags/v0.1.50.tar.gz"
  sha256 "2f2a398a01e5c87bb59deb03ae6fb55691be922bfd6644a2fdf346ec4794f614"
  license "Apache-2.0"
  head "https://github.com/JamesWoolfenden/sato.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6488c04236ef1d4f2953a8f49db992ed7c960e9adc86a16de6caf7dc3b1ed34f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6488c04236ef1d4f2953a8f49db992ed7c960e9adc86a16de6caf7dc3b1ed34f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "656eab28f44d04182f043ec584689d7090a55b3b4cbb6cb78b837d016cb06671"
    sha256 cellar: :any,                 x86_64_linux:  "02877345c21cc1846e7a9f2f217f251c8da3c653db218fac2e6d7c8fa4bcddd8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    inreplace "src/version/version.go", "var Version = \"dev\"", "var Version = \"#{version}\""
    system "go", "build", *std_go_args(ldflags: "-s -w")

    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sato --version")

    cp_r pkgshare/"examples/.", testpath
    system bin/"sato", "parse", "--file", testpath/"aws-vpc.template.yaml"
    assert_path_exists testpath/".sato/variables.tf"
    assert_path_exists testpath/".sato/data.tf"
  end
end
