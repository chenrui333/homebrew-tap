class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "ac6349614d7184bd4e3ff5a8db0bb10ed7be2fd5c16b17168ae5795fcc5ba6ba"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "817cc5dcaf4221a163b1f6a34c733825bb750990123a15e835721dc3ab9e5898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f861c7670d7035cce3f0bb3d139b40ce9c01e00c476b7f906428d2688894ae2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cde0a8b1fa8c65a83bc41beea8167fb7b7696e10526f0d2696c9552315aaf407"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "172935f05a9714a8d10aa40723ec24649adae1b4bae155041d0f9f97d1a7e585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a6f6ba0a91ea14925240248048b96e2513d18a0565aedac055527fc9e8e3258"
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
