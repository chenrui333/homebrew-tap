# framework: urfave/cli
class Pike < Formula
  desc "Tool for determining the permissions or policy required for IAC code"
  homepage "https://github.com/jamesWoolfenden/pike"
  url "https://github.com/JamesWoolfenden/pike/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "af65829493b4f39b5349b9496d46bc2914a53567d9f43b70a40e57b9e9252816"
  license "Apache-2.0"
  head "https://github.com/jamesWoolfenden/pike.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7db58cd767a737a4280166dc240b56a3cde88edf06a186a4f54c5c5226cda40e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "681f46afa8b5992652bbf03cb80169919639280cd1d454e476a9d610ac7fb8a3"
    sha256 cellar: :any_skip_relocation, ventura:       "0f884761d00932eb3c084ed4415b8647ebcce9a2705693ff2494fa19148e6dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b88ae739b1ed02a925ade0d4327bb891e781a9b90acc4be67a899186203dd389"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/jameswoolfenden/pike/src.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pike --version")

    (testpath/"test.tf").write <<~EOS
      resource "aws_s3_bucket" "example" {
        bucket = "pike-test-bucket-#{Time.now.to_i}"
        acl    = "private"
      }
    EOS

    output = shell_output("#{bin}/pike scan -d .")
    assert_match "s3:CreateBucket", output
  end
end
