class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "aa23b1a085bbaf3a40640ea2a854307664da06f959fe52e1b2854e34cd58d683"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bb55b1479e3b65db833102eca6fe2e3437ef154b703e71a857bbd6ccd1ab0a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d79bdcfbdd8a46f2d644149f1a334aac03eaa5758e06c963331bbf4f08bac962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb066a7590ec626a3275d1a5824f74367bb3a1a05778ebbfeb9a8749c8b71fcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a70bb799cc428afd08f4f26558335cdfbcc2701e16c3e13299031d5dd994ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de1d55370378fab6ebafbb0b096edd5d50866aef325aef47ae66ae9f89099c2d"
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
