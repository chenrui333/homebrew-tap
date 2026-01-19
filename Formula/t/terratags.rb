class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "1cdcfdb4ca21fd3318c841030c359c758bcfe12b901934e195fb3839d69b5995"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf37c7e20213d8feaa85bfa71bc343ea2ac848fc9b98e8f6013c3061b9cd8bf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf37c7e20213d8feaa85bfa71bc343ea2ac848fc9b98e8f6013c3061b9cd8bf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf37c7e20213d8feaa85bfa71bc343ea2ac848fc9b98e8f6013c3061b9cd8bf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f28fa40d31cb1afbb59ad256ccb4ea5198778ec7a78a6f352f040347fbd06a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f8e7bd98f282c1c62c063f153c83855909854d5aed2224a26b933db4ffda8ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terratags --version")

    (testpath/"ok/main.tf").write <<~HCL
      resource "aws_s3_bucket" "x" {
        bucket = "example-bucket"
        tags = { Name = "ok" }
      }
    HCL

    (testpath/"terratags.yaml").write <<~YAML
      required_tags:
        - Name
    YAML

    output = shell_output("#{bin}/terratags -config terratags.yaml -dir ok")
    assert_match "All resources have the required tags!", output

    (testpath/"bad/main.tf").write <<~HCL
      resource "aws_s3_bucket" "x" { bucket = "bad-bucket" }
    HCL

    output = shell_output("#{bin}/terratags -config terratags.yaml -dir bad", 1)
    assert_match "aws_s3_bucket 'x' is missing required tags: Name", output
  end
end
