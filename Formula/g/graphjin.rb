class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.40.tar.gz"
  sha256 "307045b10c4ce44e06a42677c48bc42dc450d02032ddfa3e9fb614c90c56b211"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00b334eaacd9db0888fdfb19662819aa8301a35e1909e56821e9243ca2b1e2f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dcb86abcfd49742e10b1c7a28b5ef7129d292176914b251c5739f9b83ec3e49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbae1d3a79a02048dc35cb0d761d6fbf66a815fd8bd28ec22154c747ef0bebf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bb05a395516ffa2439e858dea26b133731a0f381ebabe6b38dacb75fe760417"
    sha256 cellar: :any,                 x86_64_linux:  "df0fdc109762c13f9c7a7732f8f85ed1aecaf048f3863a340706dbc70e4e9f61"
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
