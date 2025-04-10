class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.4.tar.gz"
  sha256 "b3bc71ab55f7f42a830fab242143256c7f7cc229a28dfb37f5cabcc4f4629ce6"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aca117ac1c779186852b35c5712078971a19700d4b44f20af2eaba5dc6e090cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "066a8d3ee74ffa8d5b119c627fc8335312ba50cc46caad80fc25860ab8f525ab"
    sha256 cellar: :any_skip_relocation, ventura:       "fda7de44dc44c7dec46a3f5c55b93e7d4fefd27ea1ef9389f526a743bb216937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d346495e4338c7d204c966bae545f89304dc8c9438f6078d2ce6bca72d2f7692"
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
