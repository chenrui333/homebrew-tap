class Terrafetch < Formula
  desc "Neofetch of Terraform. Let your IaC flex for you"
  homepage "https://github.com/RoseSecurity/terrafetch"
  url "https://github.com/RoseSecurity/terrafetch/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "1ac690c842b0443365d24277ea9a4f2f858949aaf33faa1e88f54976f2e90b61"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/terrafetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a719a18e014db3c4eaed51ac8022bb5bf1e461af3a0d59b1388ae1876b5b13d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a719a18e014db3c4eaed51ac8022bb5bf1e461af3a0d59b1388ae1876b5b13d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a719a18e014db3c4eaed51ac8022bb5bf1e461af3a0d59b1388ae1876b5b13d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e913a40ed59f39bf4e060dea8b4da8a14e3a80d28f991ade85cbafe9b62304fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "627e3f402fc89c4feee99b1a571e59d41015f8afa1b2104a51ef437161907927"
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
