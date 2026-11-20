class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.21.tar.gz"
  sha256 "fff8cef1b9fb129a3e8b83db6e6b8c6f2c19eddf971a58239dcaa93edf3fa69f"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2d7f5d6b0e1ac2d5e0b3f020d8bd272d8b4a135d8e49ca57e716e938f2abcf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e5e9c2c1142ad993ef310c62c1f5f0ab77356a5b6b3a0d5525f6156e6f5986"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69677f26df6ba6c63a4a43a3387a04986707c24d56051e514e0af03ec75590d0"
    sha256 cellar: :any,                 x86_64_linux:  "dc6fd1b5d2198240247d249a2962ae64d19c3b4a6a1a1755ec14fffb7b1f24ac"
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
