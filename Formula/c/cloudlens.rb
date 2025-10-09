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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d66ad5f4703f583aea9a9840c9279338863a9275a61026cf1b65a42a8a82841d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d66ad5f4703f583aea9a9840c9279338863a9275a61026cf1b65a42a8a82841d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d66ad5f4703f583aea9a9840c9279338863a9275a61026cf1b65a42a8a82841d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72badc0642bd5aca01a5fc3edd4e8a07f81a5f495b12c9c76555a157ebf81fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1af526522939528715359f3dc7e5efead14f14e0bb3b6e17ab516250040eb63"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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
