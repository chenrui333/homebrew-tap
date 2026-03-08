class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "adbd5c21732c8efc3f0e16ad943f0f5ab258f98493f409fb0bb9521d5d1a820c"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51e41d2aa8462360ad3b9330ee8c91dca22af675dc710d5a62fe0e3d3348d27e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3ed230dc7d203c4b00195f350a6dde80a14d0c5c210b4e882dd6827865b8b59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "674dc2cb63e093203b3acb135770f0dc3df547b18e535ca01c8fe17185592697"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4e3884310a15ddad6c62fbf9713e5868f6ea8b432d1274fddf74a15177bfb3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3adbff2dbba7ada9f8efd266ef6b6aa691f0e6b882049f13459979a1caf116b5"
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
