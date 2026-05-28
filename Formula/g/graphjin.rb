class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.28.tar.gz"
  sha256 "37a0f6b0088d7b5aff9f620898111445ae0f5cb97e9fb1673b66d7d5f7bb9897"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f9f975e204c6766d6f6eaabeaf5a304a3d4a6450385ac01967411aab81e5e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0d0c6283372e2d41dd082d5539397cd2faa32c4048c1a49b8a339d42ca66ee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87c5835a55b59e799c9329b2e91d823fa51b1777a69a079379118fadfdb9dabb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be3d292ee8d7db2fc91f654985ad3dbd5cdd460f679869fb315b6f4a4b29a45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e28d6e854f9f9c8029455ba1be8ecb93ac159dac1fca33af5679283522370317"
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
