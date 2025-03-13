class TerraformModuleVersions < Formula
  desc "CLI that checks Terraform code for module updates"
  homepage "https://github.com/keilerkonzept/terraform-module-versions"
  url "https://github.com/keilerkonzept/terraform-module-versions/archive/refs/tags/v3.3.7.tar.gz"
  sha256 "388f4c7aca5072e12ac5cc4e9f37c85d35f907b290d9c710bd0e73b70a5b5536"
  license "MIT"
  head "https://github.com/keilerkonzept/terraform-module-versions.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c5581e6361dafb52440b508b6dca128db58346e2cef9713d1fa116c6fed14dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0788f4faad616a03e4f2f78cf961b117d8d1fcb221c74aac0f895c50bb7f53dc"
    sha256 cellar: :any_skip_relocation, ventura:       "1d691462007d8f9d071ce7de75a8d113eb43dd208a9fca3b1f8535794a4e608b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2d71c7012aa83de6792c78906e9148eba22b2d644eacbc991e251f6ef4fb7a3"
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
