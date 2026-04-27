class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.6.tar.gz"
  sha256 "7851fad38115b7d5d428fc2ef4182076561bc2984d713a5c1fc809a12b570565"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0448111c2fb536cc18d14ffc89f552c99eb680cf3b7d3b31feb748c9c8994dec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0a0175f41b9a5319c89fd2cc12ebd02327a51e83c532e91aaa85cd07f80ee0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ae0cf5352f5abd3205f2290da7704d69b32bf17ae9f0af6312e31765f580624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e577b26904b698e49674ec4a369bd7b9ab362ea866276a956d0e7b12ecd9e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3491efb5863706a8180a5251b80c52235df8ff5ce1abbf326527da985e222d7"
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
