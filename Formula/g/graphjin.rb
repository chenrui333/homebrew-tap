class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.44.tar.gz"
  sha256 "8b1c1848d686d48b43f8255edba586fe78cf2953076dbfe9f3cf1e43360290bf"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f00be0f421c848924d5e072663402ba73c9ff24a826cd1fe2c8c93c3028840c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6836218356420cd597555e8bb5784c67ad6cbadcdf72cb35a0013b5688a122f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b558a235f07b5c1b6541e5cdcaa2362687e9acfaafc471964f0888689a029ebd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba0a841b821d7344aaeeac75a3a6e0e5c4dff86df5d7dec0c1d7d8f3f404b00f"
    sha256 cellar: :any,                 x86_64_linux:  "c86c62adb40fa782ab8587e990b4b77ca8b360a9af2cfed37ef663d065bbfb93"
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
