class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.7.tar.gz"
  sha256 "5b60cb29885387972ec619b1414c96f04f13257758ea19225f806c868dc75bde"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59fc2759d31e0115ec32f92e4ead506d5f36a3400135fa84f0a7d203016a9919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b1e64539c6d23de917a777d8e3925ac534790906c8a389f6ec1e133cd9853da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c295644f65f4477986214b899fb1ab08b8396eadf87cfde63d90ae34a48ccd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82f3e45d3ce5f712438a354791a778761964472884fae10358fbc00724abc02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1bae1b20aeacd5d0638802db8d70db91aa91c9cc2936d66e3a15f34bbefec26"
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
