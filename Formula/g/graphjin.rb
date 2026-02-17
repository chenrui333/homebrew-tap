class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.10.3.tar.gz"
  sha256 "30a1399336a60a0186718a6b9b0d5c59c04ab37daa123828a5062f2c49649ae9"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0db436431c2ce408dcc410af046096907d8fe40bdeb25157aeb7e5a0b70558b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e98ac6375eddc366288166e7b8088d4265d232c499c0bb091eed56feded8fa02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d4c8b2c2624a428bca4743900f6900c5a213eaebc2a038ac47a333fbf32f005"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c948d30f6222abc3999d9cc16ec22301b8bec65a220f43d2dc9ca1123546d264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62acdaed00c03dfeaaa86cf04581481b33eaa6427dd084a12da999e8c9f9d5b0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
