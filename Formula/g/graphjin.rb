class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.14.tar.gz"
  sha256 "eedee8763dbf42774f8baf66964b466ed83623e7a1a84c206e5ec8ff15c07c0a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3498122591904989b4eecbebe2e83ef9f02fbf8095241a894e58687553188403"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66f0583d6e3b07de1e394819c5465ea935befa419ed98e48c2f802513cfbd946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eef40cf13073de22f0124a32fc8dfb178257c7c995eb5691baa86815483bc8cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18f4c025ae22f160bc3446661fb95f5e635c1c9b611d99c84ce8c77ffc067d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54a33afd3889e25bc3e8b293788b4b53dae8cc21bcd0af9c391c8bbe1245bba5"
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
