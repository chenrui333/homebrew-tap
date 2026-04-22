# framework: urfave/cli
class Sato < Formula
  desc "Tool to convert ARM or CFN into Terraform"
  homepage "https://github.com/JamesWoolfenden/sato"
  url "https://github.com/JamesWoolfenden/sato/archive/refs/tags/v0.1.49.tar.gz"
  sha256 "ce8390f210a8a90340bc27c612f9cf2bfb1597bd33a5976c37f8776a4faa2e10"
  license "Apache-2.0"
  head "https://github.com/JamesWoolfenden/sato.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "368c815862cb89f53b91b0b7e921595247195afc00c02ec79d9a7d1e4abf8f29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "368c815862cb89f53b91b0b7e921595247195afc00c02ec79d9a7d1e4abf8f29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "368c815862cb89f53b91b0b7e921595247195afc00c02ec79d9a7d1e4abf8f29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8b3b76cefff824210beb54b9f7b39348bd3b84bf38ee10fd317d31215a8afe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dedd1a23963aaa4a3ae7e55c79e3799dd0a9c6a9772eb8a995642fa7892259c8"
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
