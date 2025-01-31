class Hcledit < Formula
  desc "Command-line editor for HCL"
  homepage "https://github.com/minamijoyo/hcledit"
  url "https://github.com/minamijoyo/hcledit/archive/refs/tags/v0.2.15.tar.gz"
  sha256 "70275f7651162863d7c9f2a96f034e434fff7d028d03b9adbc57e0247a37d6d1"
  license "MIT"
  head "https://github.com/minamijoyo/hcledit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dde7937e2293cadd9a4b87b8ca1c92d5e856056ca2f4f0e6c40230983071809"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64c8c310f6247c76ac1f1d4c8fa53c22b57f2686c1bb707d59409d836a7c7ee4"
    sha256 cellar: :any_skip_relocation, ventura:       "35fc4426f92293b5aa9e43b4fb374efe6a081ecf3b027c314c056bef16d3a548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e53d63c6ef70956d05c14b77b8e99dd623c1e4b286fa9e245afe5db7dffe51e2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/minamijoyo/hcledit/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcledit version")

    (testpath/"test.hcl").write <<~HCL
      resource "foo" "bar" {
        attr1 = "val1"
        nested {
          attr2 = "val2"
        }
      }
    HCL

    output = pipe_output("#{bin}/hcledit attribute get resource.foo.bar.attr1",
                        (testpath/"test.hcl").read, 0)
    assert_equal "\"val1\"", output.chomp
  end
end
