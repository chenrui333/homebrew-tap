# framework: urfave/cli
class Sato < Formula
  desc "Tool to convert ARM or CFN into Terraform"
  homepage "https://github.com/JamesWoolfenden/sato"
  url "https://github.com/JamesWoolfenden/sato/archive/refs/tags/v0.1.32.tar.gz"
  sha256 "667d288a66e12248ebcc6365d13e02a89af2281240ce73f5f852bc69be4239d1"
  license "Apache-2.0"
  head "https://github.com/JamesWoolfenden/sato.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e961d969e74e97dd8822f0cfb54b74aadd50da3c0e79e57ad2df4eeda6870f03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d8d3c86bf01cbd9e3ebcfabf355597c6bce2d3642d76a90c3347e72997a0938"
    sha256 cellar: :any_skip_relocation, ventura:       "91d617e821178a3cfb69d2c74716c362dd7cf51cbf8ba620cfa219579fe1b301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f64f083ccb2d230aee1240cab8b4562d256be84c1820b1f16a85f5fba3d5e021"
  end

  depends_on "go" => :build

  def install
    inreplace "src/version/version.go", "Version = \"9.9.9\"", "Version = \"#{version}\""
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
