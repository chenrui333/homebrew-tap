class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.27.tar.gz"
  sha256 "56634850e5db6e7a4169f38fbf99f9422a86f591003cdbeccc86c8990e24c02a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e58430972fca35bea8bd598bc756412a7bb48edb96bfa801c2d08e81909c613"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64e876dda4a467f50ccd4637e99c9147fa4758a1821bdae45fee387d962d9d1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d55e26cc2021e0ed0cbd32fca9ccdc2cfc4980d9053c081fa05b37fa4d03686"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18174a26a397e8148d7b8d3f937b9da44be4ed6e9bc66a60fbf5a5d76b187d56"
    sha256 cellar: :any,                 x86_64_linux:  "81fb90cf889dc8c9123cd3d0928c897f26c5f4f0848bcb730bbc43bb11a82ed2"
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
