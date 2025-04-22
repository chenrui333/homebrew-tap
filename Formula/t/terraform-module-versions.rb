class TerraformModuleVersions < Formula
  desc "CLI that checks Terraform code for module updates"
  homepage "https://github.com/keilerkonzept/terraform-module-versions"
  url "https://github.com/keilerkonzept/terraform-module-versions/archive/refs/tags/v3.3.10.tar.gz"
  sha256 "c84e947c26741e4c95d9c0e0a5e7d01d41ebcdf7bbb85b0106f1013b08e20b05"
  license "MIT"
  head "https://github.com/keilerkonzept/terraform-module-versions.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3641784519af4822af2c9be801563ae48aecfafe6a2a3daed3bbe3f699714687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09ae733deda43f08c246a670dc0bb297e2104a9eb115457e74b94d02035d0d69"
    sha256 cellar: :any_skip_relocation, ventura:       "98c0ac0fb8a1716c0ae20c5fc030ace997acf62c91a0ef2d4da14ed2df2c9a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe536af5d39c9a9559987508e9fbb62059408d963e5a51f6ec32b6b6c06c8223"
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
