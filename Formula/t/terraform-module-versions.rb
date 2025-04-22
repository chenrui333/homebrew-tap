class TerraformModuleVersions < Formula
  desc "CLI that checks Terraform code for module updates"
  homepage "https://github.com/keilerkonzept/terraform-module-versions"
  url "https://github.com/keilerkonzept/terraform-module-versions/archive/refs/tags/v3.3.10.tar.gz"
  sha256 "c84e947c26741e4c95d9c0e0a5e7d01d41ebcdf7bbb85b0106f1013b08e20b05"
  license "MIT"
  head "https://github.com/keilerkonzept/terraform-module-versions.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31871c13c8e8c09cf520601e488e69ecddc3012fd419272668fb157324aa5040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53e10bbbd15a56e92c70528de4a5baf184fccc5c381407933bd1665d18e595c6"
    sha256 cellar: :any_skip_relocation, ventura:       "257e31d22761d44c369413e2b0cdf3f4eddae84353be719ef2057a6b90b29a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9be9cc3926069e931f567f365ce2381f84186f13f9591646fee5b634ad2bce1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraform-module-versions version")

    assert_match "TYPE", shell_output("#{bin}/terraform-module-versions list")
    assert_match "UPDATE?", shell_output("#{bin}/terraform-module-versions check")
  end
end
