# framework: urfave/cli
class Sato < Formula
  desc "Tool to convert ARM or CFN into Terraform"
  homepage "https://github.com/JamesWoolfenden/sato"
  url "https://github.com/JamesWoolfenden/sato/archive/refs/tags/v0.1.37.tar.gz"
  sha256 "ee10611e1d481f811b4db5c7cfd44bc0c90bac87dca0164871cd9a77a8f29ab7"
  license "Apache-2.0"
  head "https://github.com/JamesWoolfenden/sato.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4421e142b999de162df5cffe78b13d18f04c3c9c44e16c147fe525affbdb2303"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4421e142b999de162df5cffe78b13d18f04c3c9c44e16c147fe525affbdb2303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4421e142b999de162df5cffe78b13d18f04c3c9c44e16c147fe525affbdb2303"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb30fd29852a1d12e29cd9a2c301e1238a62ccf1c78c1dcd9397eed67a47899d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeb4ba3c5ec16218d88ea9cd4aec4a2752ff21d3e92f72cb9773e199f2823b7e"
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
