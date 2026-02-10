class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "e5238a35930eae334f7357376b617f73f2695c7c684685befaa325939bba884a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9c412fdc3bce5faf903d8015ee96b028fd50d866881d5029d52004a23f6cf40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dfff754bc9e9d26612eac41d10fd0a2016899018bedb81c21b462d300225292"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b95ae9fb94cf33cd7900dfe813ba1f5c85deb7341f4d161fbcd92e0e93bea37d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33f13fffb7298538183ea683a91751afe5e6275ae8ca134a5cf50833d63399c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2896d99c2645180f3b4e49d69be943269fdc9487158ceb2795fc012a055bd543"
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

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
