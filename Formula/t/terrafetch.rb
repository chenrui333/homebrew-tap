class Terrafetch < Formula
  desc "Neofetch of Terraform. Let your IaC flex for you"
  homepage "https://github.com/RoseSecurity/terrafetch"
  url "https://github.com/RoseSecurity/terrafetch/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "8050217514feca77c2b33faa114a3b92893494387ba754c3219108e3345088d0"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/terrafetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a180b7f2d6c8d8fb05dcc20caaa6321b8bdb72a8160900d3630d8a2dff092595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d74c84434e47540f15894d7938c3f9fe47ce1a14d4dd63c342f891f775d99c92"
    sha256 cellar: :any_skip_relocation, ventura:       "0b6fc23aee1f7fec40d53afcb195e5fff3f4b41e8de79c46f75b8b1e3b6dde59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16c45ef1cb2789a06f076d00ac43b4796f0e260e7b7e06998efd331b5277abdd"
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
