class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.21.tar.gz"
  sha256 "6722f38e5fcc6f9ee40cc7762c74a66b3c54f76fdab3553d3307b59e622e85e8"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7beac154609daec30c5b382bef8d643f9163aba265a1d6b31d33541ff87dc05b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e109c8ecc121c73f29ec164d252bec279947c66559a07a658e0b1ed00b9f393f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e82909d58385ec308b0a5aceef8c6c52022116a8bd1e1fa78632edc4c6045e3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e51a088c18aad900b08dcad6d00263801af70943cc17c3761a1504fdab0d55ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b155fe38d140b1827eccb07fa2f34dab07d944d544635fd2c695c750512e84dd"
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
