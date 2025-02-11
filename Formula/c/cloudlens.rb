# framework: cobra
class Cloudlens < Formula
  desc "K9s like CLI for AWS and GCP"
  homepage "https://one2n.gitbook.io/docs"
  url "https://github.com/one2nc/cloudlens/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "d049a756d2ad6198755dfc6e467f44428c043a54d578fd7938962c3abe15d78d"
  license "Apache-2.0"
  head "https://github.com/one2nc/cloudlens.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/one2nc/cloudlens/cmd.version=#{version}
      -X github.com/one2nc/cloudlens/cmd.commit=#{tap.user}
      -X github.com/one2nc/cloudlens/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cloudlens", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudlens version")

    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    assert_match ".aws/config: no such file or directory", shell_output("#{bin}/cloudlens aws 2>&1", 2)
    assert_path_exists testpath/"cloudlens.log"
  end
end
