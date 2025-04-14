class TerraformModuleVersions < Formula
  desc "CLI that checks Terraform code for module updates"
  homepage "https://github.com/keilerkonzept/terraform-module-versions"
  url "https://github.com/keilerkonzept/terraform-module-versions/archive/refs/tags/v3.3.8.tar.gz"
  sha256 "abea7352e65a7577bda927873797d99442c9074e37b52b585c74b3d8d5db963f"
  license "MIT"
  head "https://github.com/keilerkonzept/terraform-module-versions.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5d85d5740e54894204a3f26836c5c3db463dee1f1c09b8fc73c0b5682ba1ed8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e964b9a8c2db275a017d2449d585e5f49598954422aaa4a68d33cc8e1040d381"
    sha256 cellar: :any_skip_relocation, ventura:       "acc8b9dbc8007a7b4884f9e80f3b39d6789bdb36e8df0bedfe4f305338b683dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a04e173a29f420dd30d96d3f7cb784dffa5ec6e1a6bc61bacaf5bcd76f0506d3"
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
