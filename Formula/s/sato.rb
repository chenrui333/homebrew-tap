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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e49315c6b56083a67267115621ccdbb99b359056bc1c48c129995a0175512b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e49315c6b56083a67267115621ccdbb99b359056bc1c48c129995a0175512b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e49315c6b56083a67267115621ccdbb99b359056bc1c48c129995a0175512b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc7a5b1530a1e0fd7eeac8b7109c4bf93c8ee29b013bf6448764f4d449605b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "306ce0c15128d96dd3b2a9c7643aaaacab4b838c1c758ef3478f63c85cfdbc3e"
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
