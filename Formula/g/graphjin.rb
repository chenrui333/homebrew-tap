class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.13.tar.gz"
  sha256 "6031cdc7e406c8217f48ee8d8dc4d1881b06fab13069035bf3efde46f9488404"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fbf2e81d33792cd5cfaa5872030f441219b0926421c1f6b1a401a9ce7e78905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78ff50989686354ac5bdf89ba8a11f53c632773a548be82b68179178ea113f03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "446e04bbd0d41530de0a59b890707271988eb745c651b6efd06ed0af3facb49b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c234055277ef07f70fd451d4b6baa6a2c6af8b42fb107c727a2424a1749a6c7"
    sha256 cellar: :any,                 x86_64_linux:  "c7119934b042de650c17d5f73443f035df0084ba02ca231ef37b69f9a5dcd300"
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
