class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.19.tar.gz"
  sha256 "fc90427279b0742da8ccb082a26e7c0d7988961d680b6dd4a5933b03431e140a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "913fe41dbc32cb4bfad90b555ec4b511a6f4be405812507927f5d5e0c717f6d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fc7d73323f154506d5a6cf04480da4d42fb68d8531da67827daf0c51ff54705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af532fb75cbc6d1c256761b44c3c71c7e26bb7616e8c89414560ac31d93845d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "454e551cc8e4bb3b59611c582afa1bec9c86fb5a22c255516534362a9532addd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e3883c58c8e519b50a46db8d890c6f7369b2a9737c3bdfe3f998a0de0626c25"
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
