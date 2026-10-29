class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.17.tar.gz"
  sha256 "33829f5aa02368b07f48e64d9b2df130a6751d5fd7a068a296d1da9f2e9681b6"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56e0e7de1282c5cf1beb38dd06d44d99704c142ece5430b13a0a451756aae6e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb0457d96b2052b7cd0c4a69fb174da7b8a6c1a74c9ceec523786a089b8fe10e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db10c314f216921d8da39e27b2f70c65454457ae193c0b72944745780f6d1b78"
    sha256 cellar: :any,                 x86_64_linux:  "4675ba2b1634720d17fc18dde97bc3a927fca3b29c98b39406c3616b2d3089e3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "cmd" do
      system "go", "mod", "download"
    end
  end

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
