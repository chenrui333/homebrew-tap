class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "46d2d1ddb158a6ceaec2730ccd95d92dc23414045b8309011ccc51352ca86fd0"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffa1ba6b8d8ddfc451a491275be3133b5584b7452af955aa6b4ec3c8072b1c19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb8f2d108e230dc7bb78e64287b7e59347984ba9edbb2815bbf16331bafdefcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "932d7f7d1acd4a912d6a3dd1f291f9bcaa46805da66bc2be5a6959d58bdeec3a"
    sha256 cellar: :any,                 x86_64_linux:  "426c4ccec02bb8f53b6dadabbb86476d51467172ecf54ed5e14b6c524dc3c779"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "cmd" do
      system "go", "mod", "download"
    end
  end

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
