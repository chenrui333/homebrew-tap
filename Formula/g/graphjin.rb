class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.19.tar.gz"
  sha256 "0ab7f03c318724cd4dc03320cf4c250307a0f0cc23659b16219b2c1c1e095900"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "261aa6e7a2ffb1d614b14d4f28109b72f7e975fdfd5c7c451384dec1a174634e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b38dfb46feddf2e2aaa87168361325f4e74139d6537e8a2ca0c457bcaf4bd2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ac6941927b82657189945132659236db43c7b7d1eeafe092e27a35d699ed665"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38b11319c0e3ad95985b972b99032ef82397bc66f753ee582f49c2d4ddba9e44"
    sha256 cellar: :any,                 x86_64_linux:  "202fde586d4d6cb34ec72f6bf92376c7e3c6f035a946a0b70297b0707ef0ef96"
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
