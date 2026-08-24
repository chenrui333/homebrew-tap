class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.51.tar.gz"
  sha256 "5e4ed230382581590dd228cb3d87cc8f349ee032ea61cee600e63a19e7e88718"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14454cec22014eac3c76f685e71649ed1e2c60b092bb8199b7fa0651a1ebc62c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "181721f2a124e9a103b15035d6b48700f059427077a100f9d111fef9076ceeb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de472ed607a317f289bcba5ebfd78bc29cb17a90061c2846b1571f3edbcab837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15fc77e732655b51ac23f395dc1b0195e92922336ded4f95e48bc65281ab7973"
    sha256 cellar: :any,                 x86_64_linux:  "56dca3aa2bd2bafe22065d12ca1b8fe40203fd9bb9bf6d9fa6fb6eae52cda42b"
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

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
