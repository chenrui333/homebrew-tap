class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.2.tar.gz"
  sha256 "f42c17ff7f45c899ef2e73ce7ce2fca1feb307f3a7d5b4cc58a819e7a4f50dbd"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6251b4e2e4719cbd3375eb84c003a5c99e458e791d7c88f814c2d56fb6edaba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2846674fc6fa446173ffbeb6397abb796e18380cc7f572daf77cc6d28ceb838"
    sha256 cellar: :any_skip_relocation, ventura:       "e71be076054d5d9d91892b2a9acca02b5ebced6233a5d03789de45fc2ecca4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4315c1b1064fe777ebf0282ccd29f43c2548ce98fd68b25ee5aac4815f07af4"
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
