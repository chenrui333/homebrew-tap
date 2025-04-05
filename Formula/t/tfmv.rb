class Tfmv < Formula
  desc "CLI to rename Terraform resources and generate moved blocks"
  homepage "https://github.com/suzuki-shunsuke/tfmv"
  url "https://github.com/suzuki-shunsuke/tfmv/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "67bb684c723d2abdfd0ecfbce030503e05940103305ee131c6b4da64f86c84b9"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a14a82ecd6d172d8605cb9099756eef6d30610e4d504ccfc12bded10a0e6e09a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f22e9756773839821a5c6236b27d33f45d325d2d3a0d56d908aaecfde18dcd1"
    sha256 cellar: :any_skip_relocation, ventura:       "6d86b6b1546fa9ceefb7f47dd202da9db96f9f3fdc48fe8fc94d6b8c4efb76c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d24be4113175a6a54e63f386897fe5272fe86aa26af269254ee7155be71a6d35"
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
