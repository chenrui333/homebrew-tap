# framework: urfave/cli
class Sato < Formula
  desc "Tool to convert ARM or CFN into Terraform"
  homepage "https://github.com/JamesWoolfenden/sato"
  url "https://github.com/JamesWoolfenden/sato/archive/refs/tags/v0.1.34.tar.gz"
  sha256 "6e9be240d6fbdd747886ec4cdcc02677cf5e36a725e3f642e89696cca7152902"
  license "Apache-2.0"
  head "https://github.com/JamesWoolfenden/sato.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d0f88ad719828d0089dd0b6889cf1cd82aaa8005b55030f345974e8f06e20f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0320125785758b8b43eedeb69b5ecd1143ee4bdd1094e13367e36ea3bd03122a"
    sha256 cellar: :any_skip_relocation, ventura:       "a748d0ac91106471af823a6e1e8b302f0276d2945d2256e9c16564f45c436930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9860fe8f54e0f0b8b67e08eb43d73bf27a24f102ab11cd171136517b7ec6ad55"
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
