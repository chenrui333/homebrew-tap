class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.40.tar.gz"
  sha256 "307045b10c4ce44e06a42677c48bc42dc450d02032ddfa3e9fb614c90c56b211"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "535c22f233f70aba85051fbd3bb6e8caf7f13c7e5512682d38965e1fcac2b64f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e5f3eec35544b9a293308bc63238cc9111e28f0037e216fc7b8dc55fcbc09bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b8bbab9574b19ab9af5ffce07f6ee8c22bd8e6aecaf664867ec77228405c57f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e45146d1de79d26e765cc79ba7eef2ebc155d3878c181d64a4f49bfcf326803b"
    sha256 cellar: :any,                 x86_64_linux:  "8d949be370c0bd9c3057e38b2ea51ef67383b190212d9b77c6af99b94578d44e"
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
