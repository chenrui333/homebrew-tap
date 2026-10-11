class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.7.tar.gz"
  sha256 "a97c76ce4ff0d068bdc20c4bd855881da167fa52232759ce6dde1438879f0bff"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b15600d26a5d954fe7675fdf942d42e1daf512fecfae8fd43bb54fccad6a36c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1406391802998ac4c74c2714aedac2cc3066996cdaa39a0fc03662e641d0d448"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16d6ffb03c654c6a2790cdbd02b9107ae3ecdab5f184ce6ed71ef8cd69372a8c"
    sha256 cellar: :any,                 x86_64_linux:  "2d1a5bbbb51a591bd143f06b5105ee5bf9ff9adae3005afbc1dfbdd2aab5bae2"
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
