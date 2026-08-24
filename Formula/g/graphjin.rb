class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.46.tar.gz"
  sha256 "4bc77cbf8acdfd87be1ea4fb4fb6a3ec7d16754d5949498429e9a034bc9b3828"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b772b60e9178905bb3b393fd050704730cb3fb48a52d49bfa61feddbc8cf09d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cee08f99581e3873183ebd77b9298f79fda6fbd1a5a66df6e96cf1d399d80bba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba7d0b3ceb3f7b1e6f72c871e08a9fcdc15d19ae86cd5dafb927c27f39cf531d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ac113e0bed7f06019acaf9805f0d2e4c3fcb1df7b486c2f008c47e44f1c1e2d"
    sha256 cellar: :any,                 x86_64_linux:  "d19642ff10d975790f210c76b53185f139b44f4f6890c7d3a7186bc809f0f258"
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
