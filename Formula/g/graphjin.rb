class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.2.tar.gz"
  sha256 "b7b7b4097d6fe01342bdd5f0d74ba441237a1dee52a2f177cf568abcba9324c9"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "507c87e374e0b7c5da5b33fdab2c6fbb995ce442350f00e91ad883ffbf3463e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f69026b44b3be6136d3c6c577e451fb8a47e378806548a764c166a2bed4c65e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b8bf2bd19de9b81eba529b44aa12fbc46d4a2284ad5bb2dab26870033931641"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "262b7483e9e4e2774e11fc70d0aee8470b8b9197efdb83b6ff077f0a53d4b57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b7299258842d081fa9a56fa30172a8748a35bae2cefe186cca1d42a18db7f86"
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

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
