class Tfmv < Formula
  desc "CLI to rename Terraform resources and generate moved blocks"
  homepage "https://github.com/suzuki-shunsuke/tfmv"
  url "https://github.com/suzuki-shunsuke/tfmv/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "67bb684c723d2abdfd0ecfbce030503e05940103305ee131c6b4da64f86c84b9"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "305d13ef58ccf81b689bad6aa93a2131585c7ee764e3fb9d75ed8d0ea6d95474"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91656f66fc964d331991e0583bf49a688149984e609a3945f6fe26aab9a469a1"
    sha256 cellar: :any_skip_relocation, ventura:       "a4ec09d8507c5391c59904181bbe81ff02501941eb267e005e9e07eb2eae6fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dec929e2000a36030ea94055b880f5bd5805222431665756990ddf386bf2694e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfmv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfmv --version")

    (testpath/"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    output = shell_output("#{bin}/tfmv --replace example/new_example main.tf")
    assert_match "aws_instance.new_example", JSON.parse(output)["changes"][0]["new_address"]

    assert_match "resource \"aws_instance\" \"new_example\" {", (testpath/"main.tf").read
  end
end
