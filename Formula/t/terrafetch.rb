class Terrafetch < Formula
  desc "Neofetch of Terraform. Let your IaC flex for you"
  homepage "https://github.com/RoseSecurity/terrafetch"
  url "https://github.com/RoseSecurity/terrafetch/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "8caca8aa1e796f6c96532b436ca50cdb8e796a4fa9575fe96a61294d26b85d58"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/terrafetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38b422b7964c6226d6185efb3d51cf619a6c5cb9d7de950a20fb90252d6b27bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38b422b7964c6226d6185efb3d51cf619a6c5cb9d7de950a20fb90252d6b27bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38b422b7964c6226d6185efb3d51cf619a6c5cb9d7de950a20fb90252d6b27bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57389a23b4e2f898ab78d24f69548d8c011fa6f1eba89f0013a3e22a182a2e0d"
    sha256 cellar: :any,                 x86_64_linux:  "54713e3c6c76c06b6acd3d79cd174521efdc9866b0f67f37fc188d953fa27042"
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
