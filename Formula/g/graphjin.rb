class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.10.5.tar.gz"
  sha256 "7b560473d3de848a8df23d4fe8c9285964fa9825a34a772fa33ee07b0ba1d463"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "702a961d0e8b268e9170c2be2f01706e8c81735792fc53e89b7918a163297ed3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bd95a8926b666e5a967034507028b536f540f08d5ccaef4fc64a8eb75db51ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33707ae73bb90d902609fc3b2a3dc0383d5c0c5d3ea557b8aed793c0f1e98513"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb0e0c885f325e09c7978754a130d3faf990dd93367873de0a3bd9b8c808b20f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84c73d6d2e188c32646120dc8485294f3597446fab54f9668512d8830aca9a3b"
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
