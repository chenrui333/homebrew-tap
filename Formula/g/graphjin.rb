class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.17.tar.gz"
  sha256 "33829f5aa02368b07f48e64d9b2df130a6751d5fd7a068a296d1da9f2e9681b6"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d29b012ea79790d0e887da8a01098852d5208e64233647dbd3dcf7d448204aad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4f943f575de524634370d910441d7e8e4dd81550e9cb500aeb11fde20e147b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "410b53e97eb4c5d6e8444e6dab5650720d9c7f3d4d637d40ac2dd315ec0557d1"
    sha256 cellar: :any,                 x86_64_linux:  "7f76e753c0acc1a157546b2ce94cae8bfe8d6cdcf39b20f03f7b1bad48838881"
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
