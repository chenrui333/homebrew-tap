class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.5.tar.gz"
  sha256 "a32de1e3ae222caa080520d88b10390bf29dbbf0faeec0a9d9bec987a3802a4d"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a92c82c134a081ca571d2882ed8bfa1b9195d32ecc2fc6bc7e0be1016f15d22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df478b8765e8f7f1c953354773889993c3d2395a3f9f068a2bc6e49b3f399fb0"
    sha256 cellar: :any_skip_relocation, ventura:       "1deb6fff46c8db4bea5c99af2c04469f5fd80850128b49b944cb7ed200738a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebfd601e525e6767c8fc3303eaba417830e233376367d227a5a62487e9178a9a"
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
