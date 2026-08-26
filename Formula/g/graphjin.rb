class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.57.tar.gz"
  sha256 "e977ee7ddf639d2342e8439fab1d7df45aaa7fd2bcbde6b4cd1fc81eb8db1a6d"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49465f63cfdbbe72b95e126d188f7e6de6ac15714b1bbc218dc39be7ed35fa5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbfec16b6cc18de1eb8cb73a943875252cff6e51291d754fa1d817f6189b5827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "109247933d369df22e192944f95859f34d5beb192966bf3cb981b94b98097555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98c5a5b8aa40ad46518be960bfc418432bd8c5f207f7ddbfa0b06f51cc75aa03"
    sha256 cellar: :any,                 x86_64_linux:  "5a84893352bc3f5292a1e0e648f9945e63f5a700b092c975061683bfc25d5f7d"
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
