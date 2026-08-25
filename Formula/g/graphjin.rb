class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.54.tar.gz"
  sha256 "b73ffd84ca183eb8d31d3bde9e9974c4ac3f26a2ed3560199cf75fd9adaa306f"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb850c754b570c23160ee58ba29c1bea4abcba27d4d7ae02443f95e4c4e72070"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7360f4e6297c5afc88edfdb526ee488c506daf1c4d2bb45c29538db87adff461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "555e2c9a0260bdc3321295f3ede306fa19a534fe4153695622b4317431d53d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01d92ab161ce48ea0532a6392f7085c0a8b9bded91c155ad89200e61d5b42c50"
    sha256 cellar: :any,                 x86_64_linux:  "f85b35fea2e4c946298f62bac05907427abfd64e9f203871eb296fec3e185e57"
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
