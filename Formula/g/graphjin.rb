class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.23.1.tar.gz"
  sha256 "5378e0d9b2728b24f7be8e44e4624ae1c33ce9d9d731ca934ad7ac919a7c41e0"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "377cecd2bf5dd475496b80fada168db285b681998dbda1393a5b7cf4b83b2267"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d43f37f7d0b329784a8c897289c95da6ea78d33d61ee319d095b20c3262ce3cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2906d2104af7b0bfe7079a2e8607cece8e3d7e35a928a690b739db08b7aba0ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40dbc6ed4108f9aebd995743f9c2c17e780d14fddfed3c72e112cc1fd28284b3"
    sha256 cellar: :any,                 x86_64_linux:  "26404275e93d1a440709b302c530f05f6b656503a87902fbe39a3c6e77f76b3d"
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
