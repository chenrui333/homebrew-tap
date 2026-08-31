class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.72.tar.gz"
  sha256 "20d7d298a71b68de5ae10d338ceced8034e108fb373edb88a2f48f0369bf1e6d"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b603dd19b8c00e27d7b308cac4eeb4a00e0ac122bb64bea0061affde9aa6aae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c43ab1629198da48101cba2175c436862f134271b983e38c58fd182332a7e45b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71e15295c4e9b669d40d6f57b21fc10f23c281bfc42cb21735e41d3ec9dbc1ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2518f1db3d5f53f46890db87c666d924e4d8a6a3884177b48e6181e806f7bcb2"
    sha256 cellar: :any,                 x86_64_linux:  "c3784abc988f3f1f4efbdfae7ad28bebcdf2c7fbbd587e28ba752be6ebee5115"
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
