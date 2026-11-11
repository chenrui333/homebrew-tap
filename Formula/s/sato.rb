# framework: urfave/cli
class Sato < Formula
  desc "Tool to convert ARM or CFN into Terraform"
  homepage "https://github.com/JamesWoolfenden/sato"
  url "https://github.com/JamesWoolfenden/sato/archive/refs/tags/v0.1.52.tar.gz"
  sha256 "d0a1063333dd49176abbd55e7ab44a1c71c79cd826db5a51771d54ef034e914e"
  license "Apache-2.0"
  head "https://github.com/JamesWoolfenden/sato.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd16e8e50ebba2f87bc8776c57e266fd7d2b12cdfebe7dc61e7a7492c834bf6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd16e8e50ebba2f87bc8776c57e266fd7d2b12cdfebe7dc61e7a7492c834bf6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "104d576b9afcdfa48cd6ef3819e6a50f41b44a484930bea5014ae3a159f9a445"
    sha256 cellar: :any,                 x86_64_linux:  "9788682abaef4480fb51f20b2bc7ea2eb841d3e0688f76f0fce30f373c90fa83"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    inreplace "src/version/version.go", "var Version = \"dev\"", "var Version = \"#{version}\""
    system "go", "build", *std_go_args

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
