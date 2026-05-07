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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c7281f4c53dcadf6649c8b210f76aee610a45440a7c5274eeeb07aca1011300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c7281f4c53dcadf6649c8b210f76aee610a45440a7c5274eeeb07aca1011300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c7281f4c53dcadf6649c8b210f76aee610a45440a7c5274eeeb07aca1011300"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a71365186125c55ced7756e121911e77670b763855746dccdf9f861dedbcd61d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b5d1aa8acdfcdb902163411dc3e5df780a8df76c960346af1aaa523bcfcc190"
  end

  depends_on "go" => :build

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
