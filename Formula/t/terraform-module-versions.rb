class TerraformModuleVersions < Formula
  desc "CLI that checks Terraform code for module updates"
  homepage "https://github.com/keilerkonzept/terraform-module-versions"
  url "https://github.com/keilerkonzept/terraform-module-versions/archive/refs/tags/v3.3.8.tar.gz"
  sha256 "abea7352e65a7577bda927873797d99442c9074e37b52b585c74b3d8d5db963f"
  license "MIT"
  head "https://github.com/keilerkonzept/terraform-module-versions.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88ed4e31af7eb1c8a184907fae5281cfeffef76d22d8d638949d438d4d2d46d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ba33453ffabc835dfddf8cc2094d06aa85c72bc990e4a4a9ec6cce7a9f39427"
    sha256 cellar: :any_skip_relocation, ventura:       "315148b638f71367ddec9452a75bbb72e77c6d70c63efaa488982f2e7a5046cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb4fa3c48c9fc09acc4fb95e848939ebbda8d80b3b2af2cfe7bcbd597c6f6342"
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
