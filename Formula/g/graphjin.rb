class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.6.tar.gz"
  sha256 "99cc4c8e55cb5fad13aedea35fa4f81559df0daeca76a531671d8bcadc02fb6c"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4691f002610db2e5c90e34d433f86c73a0187d632ff22748a0d0a726bdc5f7ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaeb13b44f87afd4594c9eed9e3c0f98cedc73f2452d90206b0ff3ed7ad36847"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce3101b9bc4c5c623276c1eae9969e69129afe7393bd757bc419dcc627ca4309"
    sha256 cellar: :any,                 x86_64_linux:  "39541580b607325e823d3e32a92b5e4759374999ca0750f8e75654c65697f64c"
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
