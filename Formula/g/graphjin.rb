class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.13.tar.gz"
  sha256 "85d78393aa5257917aef64b34525badb2c46a05d9abd96ce5a70edcf21f5939e"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af5f3d61212c78b69c61376acfd8aa237fdb7d979f6757f03de818d7ce503a41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae30eff77f71778a30ce567e92e3664fced12a7a3936288ca44a339117c7971f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "457e799a9dc0c4636d440589e040e3a14738736cb16024c84ff785adec631313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4c67e32808d84035c12ee9c8a9b1a409a12415f821ad01507c008547a4b11a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4a64ea24dac1b8d3a584df1714ef31a601606dfcf0a6a8fa73ddcdae3da694d"
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
