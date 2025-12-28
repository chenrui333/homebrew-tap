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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d293917c4f35fa9a577d37335939b63936c1972a9ec8b1bf9b59cc947e341f5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d293917c4f35fa9a577d37335939b63936c1972a9ec8b1bf9b59cc947e341f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d293917c4f35fa9a577d37335939b63936c1972a9ec8b1bf9b59cc947e341f5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c357a4e9b45000226d430e3dcee99f50ac54a07a414cc9ec8fd1c43a1166a02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c2730cf9e5cfdf781ca9ac829fab3c501bb16626b1efa6ec0e62206850ab637"
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
