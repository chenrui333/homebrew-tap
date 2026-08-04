class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.5.tar.gz"
  sha256 "5cb8392bced3c03f244f7607b4b8b123abd206a98916ed9455203988da88dcfc"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8f6d4bdb1156455b36ee0092c83601caeb8b6a972ed3b920d0ebb36f2ac9ed6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab8330052c1c198dfc8d54e67fa44f7e8cfc5018fae847f785b2320967d3891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c08404d90371c3c82ff18c4b6fbd94cb39bffdcd41da00cc2feb9591e6320d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "129b29e7c30251e3fb4442dbf38f8327b8742deaa775dafefa70abf8e43a4765"
    sha256 cellar: :any,                 x86_64_linux:  "93432cb38d2876787d44d00c1204ff600d6030243d6d94cd3c2c683528ad06cb"
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
