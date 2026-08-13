class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.16.tar.gz"
  sha256 "253b03a71e7327d9218a36974c420fc52737d3a479a61e712f86066a1d311934"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9c7a7f7d601b62cf992334e73fc1e52eb6db07bb3e9b7466854a50a52bb6e6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff47ffaa9e37a8b1e0995190e9085c4cdb248664238bb862ba19ba6aaab899c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91c426612da8001aeecd813f9c050fdb5eeaf84b86fd064ae391d966623cd382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa6b74a5d49b49ae91aed0ff109c31653f1f93ddcc8164710f8e0614e6fe57a8"
    sha256 cellar: :any,                 x86_64_linux:  "35d55e65440e635ce838cffab421c837f412dc8b8a060726aad53b828d98cc4b"
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
