# framework: cobra
class Cloudlens < Formula
  desc "K9s like CLI for AWS and GCP"
  homepage "https://one2n.gitbook.io/docs"
  url "https://github.com/one2nc/cloudlens/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "d049a756d2ad6198755dfc6e467f44428c043a54d578fd7938962c3abe15d78d"
  license "Apache-2.0"
  head "https://github.com/one2nc/cloudlens.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e651f79bb14827e279d544136f2280989c6c49ac9b95c9f4557d638e57c202c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f964aefbb52d1c18a718569d82b4c6e0ed52c53efbabbc6a0b129911d698b2c0"
    sha256 cellar: :any_skip_relocation, ventura:       "76fb4fc8f6040e138bf7cd3a9d56f48792ebd83dccd275b5eaba045911816f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a100349310ca0e076bbce82f717ec1004da943cbe8f9936ecda2362453900765"
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
