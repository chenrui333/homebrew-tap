class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.5.tar.gz"
  sha256 "915f80bc8e62cdd3494618ded1e5a81f10506b0dbee7f1d7a2da24757d7c0a09"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36f1ae33141e9ffc409865f00b29dffeae671cac46567ba47f6abccd2c89511f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "648f875b4cc974ed652a0937d6fc212d36bd438a884f439b3ca8f242d9adbdee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff22037cb99d334079df1a4c5effe435c76fe2da6b939f975e27718059ec7bcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "592e7a693bbf372c0fe6080eff67cedda70ae071f8d7175172346ce0a5ab7616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bb75994156b1dd99b7b38396fa8b6e9722cbe24abf2b334a93090368808064a"
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
