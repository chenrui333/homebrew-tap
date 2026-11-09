class Terrafetch < Formula
  desc "Neofetch of Terraform. Let your IaC flex for you"
  homepage "https://github.com/RoseSecurity/terrafetch"
  url "https://github.com/RoseSecurity/terrafetch/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e0d9f653562aa1201802e03fc8e407a9cce6972f290857ede557a5f5547b0631"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/terrafetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffee45a879e6095b2f458ca638d4d744291a7adb920ddd033d2c23a8a90ce005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffee45a879e6095b2f458ca638d4d744291a7adb920ddd033d2c23a8a90ce005"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95488203050e61f6740fbc64ece8fae2c4041a55bbbb1960026ce040741e1158"
    sha256 cellar: :any,                 x86_64_linux:  "fc6447be5b29662bb0d50b481eca446e3f4d7c8b5343e5f491b7af9741f01325"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
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
