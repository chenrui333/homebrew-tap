class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.8.tar.gz"
  sha256 "698024d55d01d167e384a7d6a210978246babfe9407ed26be67343ed80a0815a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fe501d09711222a5a18da9b7238b314988d5e36782a02f620cc8c2b1f942889"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ea51ea504baa4803cd33544ea51c06ab48ce108c5b46f20bf767cfd54cc0ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74fba958f712214c4dae168b61d74c6ef1f5fe52a86042f7a187c64685e9a42e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4ee5860ba0b0c1e7cfcf081853ea346ad9ab674d5f9e6a28e325fd5abb92cac"
    sha256 cellar: :any,                 x86_64_linux:  "d1427462c6853df09c63589af564a0d09bcd28081b7ef544ec368cff17b5e023"
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
