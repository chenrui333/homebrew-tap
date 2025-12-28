# framework: cobra
class Cloudlens < Formula
  desc "K9s like CLI for AWS and GCP"
  homepage "https://one2n.gitbook.io/docs"
  url "https://github.com/one2nc/cloudlens/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "d049a756d2ad6198755dfc6e467f44428c043a54d578fd7938962c3abe15d78d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/one2nc/cloudlens.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "006b14f41c54ef805e8dba806b84bc37a4439f686b081d3ef31f621b86ce1850"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "006b14f41c54ef805e8dba806b84bc37a4439f686b081d3ef31f621b86ce1850"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "006b14f41c54ef805e8dba806b84bc37a4439f686b081d3ef31f621b86ce1850"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca2c3778b32c22f7f73400d268be60451ec9e6def6b1e6d0cd991fe6ff9138c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b00692bbfc2829b177c2df5427a396b4ed791d7d1750a75cda64309557a0663"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/one2nc/cloudlens/cmd.version=#{version}
      -X github.com/one2nc/cloudlens/cmd.commit=#{tap.user}
      -X github.com/one2nc/cloudlens/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cloudlens", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudlens version")

    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    assert_match ".aws/config: no such file or directory", shell_output("#{bin}/cloudlens aws 2>&1", 2)
    assert_path_exists testpath/"cloudlens.log"
  end
end
