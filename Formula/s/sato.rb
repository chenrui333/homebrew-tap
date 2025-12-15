# framework: urfave/cli
class Sato < Formula
  desc "Tool to convert ARM or CFN into Terraform"
  homepage "https://github.com/JamesWoolfenden/sato"
  url "https://github.com/JamesWoolfenden/sato/archive/refs/tags/v0.1.35.tar.gz"
  sha256 "c39cea880a4724270d724773edbc9728e8f15544a3e69de91779f91d01bd5640"
  license "Apache-2.0"
  head "https://github.com/JamesWoolfenden/sato.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "718f16fc8d688922c136d5c9d23f35c865c1e091e6c0be548238186c176248f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e2d1fb4f1ebe056755daf28f7a8919278061136efcf410f2b52fec9f66a0b73"
    sha256 cellar: :any_skip_relocation, ventura:       "1c1bcc5df2206d3e1dd165564deeb68c7cf06287902c2f308e70ff6ce17eae78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8510feccce79d0f0c6692c1d5192ea783945c1d2d71786c20d8c1ae323de4ed"
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
