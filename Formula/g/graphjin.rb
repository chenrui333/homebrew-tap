class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.33.tar.gz"
  sha256 "744ea58987f9d163a12e1bb05b31600587ee933bead78278c5ead5c2bafbfa4b"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53620ecffcbb523c4ff92d344978d618047506eaff818745378b70fa6cb2c8a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e0c9bb1dc67de0594d82503055851a97802a11b306cfd6a87dccf2b57cf9d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a98ded5db1a6f9340490ad5c097bbb14fe83c87d6e2d3cadc9b0ee71c6d0c22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4556bae56ac934ed0398265e182ae645a9aac330e3ad6e682defca9ba57a8487"
    sha256 cellar: :any,                 x86_64_linux:  "389d2859941ffee19b4012baeba2bc35497e781002dfec0efbea24e6341273a4"
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
