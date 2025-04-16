class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.5.tar.gz"
  sha256 "a32de1e3ae222caa080520d88b10390bf29dbbf0faeec0a9d9bec987a3802a4d"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fdcd2618f67015028f778585314d4582e0ef80c75de14fc3ee4804634d81627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faa14a722c00d6c30212d3c89ed704ce64e1588c6acc6f4ad11e5013d6500f27"
    sha256 cellar: :any_skip_relocation, ventura:       "4cd1e9d16d511e34ebae58752e76a0eb3d2fed5816ac6ec0cd932c2251daa8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c04d5a3cb3551519e32f7936382931fe2a68fd10a8d3adabd0b73d86c19d1e4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfcmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfcmt version")

    (testpath/"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    ENV["TFCMT_GITHUB_TOKEN"] = "test_token"
    ENV["TFCMT_REPO_OWNER"] = "test_owner"
    ENV["TFCMT_REPO_NAME"] = "test_repo"
    ENV["TFCMT_SHA"] = "test_sha"
    ENV["TFCMT_PR_NUMBER"] = "1"
    ENV["TFCMT_CONFIG"] = "test_config"

    output = shell_output("#{bin}/tfcmt plan 2>&1", 1)
    assert_match "config for tfcmt is not found at all", output
  end
end
