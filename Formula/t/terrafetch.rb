class Terrafetch < Formula
  desc "Neofetch of Terraform. Let your IaC flex for you"
  homepage "https://github.com/RoseSecurity/terrafetch"
  url "https://github.com/RoseSecurity/terrafetch/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e0d9f653562aa1201802e03fc8e407a9cce6972f290857ede557a5f5547b0631"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/terrafetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a033db28b7b59579b27044d637d5bc3b5cf3dbf172bf4fa3e1e879f2377f680"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a033db28b7b59579b27044d637d5bc3b5cf3dbf172bf4fa3e1e879f2377f680"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f48214c15743f062aaeffb379fecff8f76e9f660688b62f8d369e0e596be4f92"
    sha256 cellar: :any,                 x86_64_linux:  "943ecf0fc9af539b9a9845b6fc44319041a916d5f9b5c090e7439a1b60f94253"
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
