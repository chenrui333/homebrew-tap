class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.9.tar.gz"
  sha256 "28ca64d5e8447099ac8b3f051a54074e2bbc54cefdcb2acb1a910eb02f14ca2b"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d943fea1d95e7d08202a78aba4ecb912deb84dbd511f7d81922cae39edcc71e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f8b84bfdc5f0dc2ab8bf030b7871eeb41681897f68a41fb503f487e65ba9306"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18ed52680d4439de22cc7cf1c918af19a2f37e3dac06d861e1df8c7f41dd836f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28c933ac0981dcdb65b0607c3bc5f239f161182c2b9beb057359e9b13b8884b6"
    sha256 cellar: :any,                 x86_64_linux:  "20dac7b5a2e9de0acdf548e59eaa6f0048fb44ad7739de363b19edbfbf298043"
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
