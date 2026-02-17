class Terrafetch < Formula
  desc "Neofetch of Terraform. Let your IaC flex for you"
  homepage "https://github.com/RoseSecurity/terrafetch"
  url "https://github.com/RoseSecurity/terrafetch/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "f8cef5394ce24441eddc4ab4404d8fd809a863ca71fd5fe6e94dc55327b73710"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/terrafetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80e14e805a18b9904a576a8e37f025f6818b9aeefbbaa109b871edb020e78cbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80e14e805a18b9904a576a8e37f025f6818b9aeefbbaa109b871edb020e78cbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80e14e805a18b9904a576a8e37f025f6818b9aeefbbaa109b871edb020e78cbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73e747f704f3ac9664bb53511e1ad5ccc14643c69130cbbab8d8b542a3d782ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74681649b980b9bfe818dd46dc9ce05192ebb0ebadffa1d5e85e2b27ba6cf806"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"main.tf").write <<~TF
      terraform {
        required_version = ">= 0.12"
      }

      # one resource
      resource "null_resource" "r1" {}
    TF

    assert_match "Terraform Files:     1", shell_output("#{bin}/terrafetch -d .")
  end
end
