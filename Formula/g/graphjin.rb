class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.18.tar.gz"
  sha256 "4a4e0e590c4cc25a3622a370076bbdf54b890cc08deebec84a6f12280321a9bd"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8469059f3313290b410a7ce29c661ed6d96b1ada2551cd4ff577140a35eb10c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9438b8f57b569c034a42933221e9ab1fc06d3dfd7952725220dd482bc38e728c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0dfce79cd803e0879d7f1cba07a0462e0f00f17d7aaefbdeb4c37c5e07ea28f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90d9b32714bc57755e0c17c6425491cc4553068aa03831bdc492e6017b9a1390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "496829363ef07772d6b9f4cc18a8c65c7ed710302d8fece31101f7f1c10646bf"
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
