class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.19.3.tar.gz"
  sha256 "6accebb4f70f9264b5240cbcb841fca9c833bc14652d83f43d32ad6c7e12d3d6"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a0be67940a3604d89915e1248164f6c5a409fdda6f6a539e6f3c87b2445a7e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbd4087fef5a0a7c61aefc20d901894f98322e926cd2f896be746aa8e996dab0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55ad10d9fd9bc2c159b99b0ed4b1ec7aa25e0d014fb59ba4fc43ddc8d95c4b89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28bd8d4de24f4e6d3e4436a290701a8cb6d1c8a797b74590ae954cbaf0712105"
    sha256 cellar: :any,                 x86_64_linux:  "ae63d3a6c1c9048485073acaaa5a2490bcaef14d83d5927ee0a9f35354c64f6a"
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
