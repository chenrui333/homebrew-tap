class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.4.tar.gz"
  sha256 "ed03e845d418d7d21b8cba010f071d71a65b53aeef4adf94e21ffe120063b03e"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef2bb346eefa9ce08f3a9ca3ca6edfb525e985fb1e6969aa043b97eda200be82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3713bdc27d257cdf2143e2dc4c46fb2c8f3b17a49cb52de264cd27ccc4cf46e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8f211daca12e260c2b8df251d3667cb93246852bc2000713779477e1880f922"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6be27cf57f2dbd57fa2ca3401c71020f632c47f642a5608d1396dc00b24cf35b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab5850ea88d4d06e4dd72fd83bd75aeabd847806560b71cccdf9aa1882d70d5a"
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
