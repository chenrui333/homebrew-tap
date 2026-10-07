class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.5.tar.gz"
  sha256 "fdf00f65bd80ab607eefd60f1da3e48f31cb9125259c848783fe348f0fc72d33"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e149be081664a5a3c0ed025e1959237703e6f2bd85de99a9def55a50f5bcfed5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d431740366f200a32a3043a56af1ff3857eec7345cd390055e0f9423a2bc44c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e638b7ac7549c8c8dfe7f866e2a8c6a55e0d78e2cac220203617d052299ef120"
    sha256 cellar: :any,                 x86_64_linux:  "6eb26541bfb6fc7ed413a27077e030852e4e5b04bcf0585f92fe1ea0fc757964"
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
