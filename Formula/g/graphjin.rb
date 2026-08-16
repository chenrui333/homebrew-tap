class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.22.tar.gz"
  sha256 "d2a453a8e8f5ec70c933a6c2ae157e2711ad7ef4abf086b4c570f927e3ed60b3"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13b163b59349f8e00804e69d71349e93a4a781a1429a62c0df1f3cecdf296a60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f577ef27de84e08295dad04014180af55732dda3de1cbb1f0f36f634e76047a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9ab7d3ae5d733d2fe6544c5aa0aa21279aa6edfb195a8801134b421f7030437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8065c43e47d6dcc142b1ff48ed2ae0d5adaf849a654dc4f98e77b7dd083257a5"
    sha256 cellar: :any,                 x86_64_linux:  "a6135de62a61ea6ce1442d8bd421712771b9c83c4237e311a49bfba0265cb2b0"
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
