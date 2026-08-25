class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.54.tar.gz"
  sha256 "b73ffd84ca183eb8d31d3bde9e9974c4ac3f26a2ed3560199cf75fd9adaa306f"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f58b347d677702818a7ce3c6f1748ec0b404d6618019fab420b6793f22600327"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdc10c916c324180008173d2b6239520e6ace827b21f5945e5e1023fd9e7591d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d21cccb13a669c99bef1478abdda933818cc1dc4cd614f53102de871a7a19fbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92fd7cf4e504e0579ce77abcf9a1d25ab8441078c1be5ba2bd97ac83bc2afddf"
    sha256 cellar: :any,                 x86_64_linux:  "687c90e970cf54e61911508654860147b481755fcdea0c6388f99663f347df24"
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
