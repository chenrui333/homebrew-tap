# framework: urfave/cli
class Sato < Formula
  desc "Tool to convert ARM or CFN into Terraform"
  homepage "https://github.com/JamesWoolfenden/sato"
  url "https://github.com/JamesWoolfenden/sato/archive/refs/tags/v0.1.51.tar.gz"
  sha256 "9567d6b213bcc23090c2f5b583271e2ca19186bdcbde89ac318fb55acff6e727"
  license "Apache-2.0"
  head "https://github.com/JamesWoolfenden/sato.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e34dd52c3ff20df5e44c760f203175d324ddc56eac5f5b02016e5d65773da21b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e34dd52c3ff20df5e44c760f203175d324ddc56eac5f5b02016e5d65773da21b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0617efcb7d0db896074b94c352c6153ccdbe6c80f28a5b4d426357557c135fc"
    sha256 cellar: :any,                 x86_64_linux:  "06ae16050e3a6049fb1ae0255f0893f685edaf857acc942b8a9dd90ed8c5c6d8"
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
