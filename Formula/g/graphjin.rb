class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.23.0.tar.gz"
  sha256 "b102d9873e247f1f511d12bc61b073d3fc81d05cb45a9c7f2a29e4e4cf0e4013"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "15b5d0026f5abc350e641c8d2d94b07be83dfea6c87aa9f84831624ff03de6a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66a45a215f62da713dcea6faecfc3cc31e2326803e8124648acb69f4c7df9fa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aedbeffc59b55878bff897637b5aab0535711d3cc6f86ba01acaee99ae7b7b7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aa5debae3156729277d29d813671d74f7f22d46dd7ab10ab84d0c6bdf466221"
    sha256 cellar: :any,                 x86_64_linux:  "f0c7eac815411c73ebc23d6a2c359986eb55a69915680be8cca78588ace37c92"
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
